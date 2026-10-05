class Justray < Formula
  desc "Terminal VPN client"
  homepage "https://github.com/luynrs/justray"
  url "https://github.com/luynrs/justray/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "eff5c101ad38452ce23f86e2297adebfe8f27750a2ce023f9781a6985d642ba0"
  license "GPL-3.0-only"
  head "https://github.com/luynrs/justray.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "227438c2a77e04db864fdaee113091d5331b869802affe390c990fbc202edf59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8419389ae8211143960abfca389269b8502341c6d6d716add1ce7d01ec3b351"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92c67d86479f5554980293ba595ee98557af1ae8f14e53aab9f41e770388d77b"
    sha256 cellar: :any,                 x86_64_linux:  "7657803ea18f79f5eb7a4e7966758eed3fdb2818def0e93d1d7f612985b6480b"
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
