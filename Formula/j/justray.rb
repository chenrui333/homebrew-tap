class Justray < Formula
  desc "Terminal VPN client"
  homepage "https://github.com/luynrs/justray"
  url "https://github.com/luynrs/justray/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "6783b00b01d530607681ab37435a3802ecf1ad79176473d6a10e1c4687e0b530"
  license "GPL-3.0-only"
  head "https://github.com/luynrs/justray.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b88f8cd1ac5b292c364d51f8b338befebc7a6aafc9eab027b4c0e7b6b08eb71e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b364135a99576e656e7c1efbe404e9c93c63544c0eb6608926e64b655608bd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67d140224b7d995db0890d07e7769e5e3572638744ca41b51577b6884bb9a35c"
    sha256 cellar: :any,                 x86_64_linux:  "bba536ed59afe5bd4493952327e62560f97764b0e285723592c31c888d88e868"
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
