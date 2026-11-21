class Justray < Formula
  desc "Terminal VPN client"
  homepage "https://github.com/luynrs/justray"
  url "https://github.com/luynrs/justray/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "6783b00b01d530607681ab37435a3802ecf1ad79176473d6a10e1c4687e0b530"
  license "GPL-3.0-only"
  head "https://github.com/luynrs/justray.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "22e6d71caaa1a915d7290ca4c99e4a0737147d5141dc3104298230fcc28b3a15"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2d181d46ba89cc0d9ee5bf0b8860c0ef706453aca6d00bd62cbac473c869f9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc26aa00f4358c444085300da94809b720e626387b4638b231f86eab42046722"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e462240df3ef7e8755c60a95d146a67ae582145ad7c9596b863373724a5ced01"
    sha256 cellar: :any,                 x86_64_linux:  "6c03fd7f6bab2cd46f5135e04722a578e9815a201da2adae851da391285e7163"
  end

  # Match upstream release CI; sing-box relies on private HTTP/2 symbols.
  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/luynrs/justray/internal/version.Version=#{version}"
    tags = "with_quic,with_utls,with_gvisor,with_grpc,with_xhttp"
    %w[justray justrayd].each do |name|
      system "go", "build", *std_go_args(output: bin/name, ldflags:), "-tags=#{tags}", "./cmd/#{name}"
    end
    bin.install_symlink "justray" => "jray"
    generate_completions_from_executable(bin/"justray", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"justrayd"]
    keep_alive true
    log_path var/"log/justrayd.log"
    error_log_path var/"log/justrayd.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/justray --version")
    assert_path_exists bin/"justrayd"
    output = shell_output("#{bin}/justray invalid-command 2>&1", 1)
    assert_match 'unknown command "invalid-command"', output
  end
end
