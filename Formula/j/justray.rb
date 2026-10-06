class Justray < Formula
  desc "Terminal VPN client"
  homepage "https://github.com/luynrs/justray"
  url "https://github.com/luynrs/justray/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "226d2b7fd4d96e716beddd9de237213f9bdd7b0613a47aa90231e40f80bb1101"
  license "GPL-3.0-only"
  head "https://github.com/luynrs/justray.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19b64c78f7ae4d98328abfc8b065a7a8c73a2616b1c551c00441d1fca7ee2c08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be2481c69bad2a1f0345c494fda6beee6a3855247baba3ff1262feb9d871c209"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "150eea99b770bded11b7948a028c3f8a21f0f30734461a99d12d44c1ef9b07ec"
    sha256 cellar: :any,                 x86_64_linux:  "7194a19fa7d4bd3c0c866e7a40e1126f51ac7d124491f91025bb1195658cc3ba"
  end

  # Match upstream release CI; sing-box relies on private HTTP/2 symbols.
  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/luynrs/justray/internal/version.Version=#{version}"
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
