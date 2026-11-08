class Justray < Formula
  desc "Terminal VPN client"
  homepage "https://github.com/luynrs/justray"
  url "https://github.com/luynrs/justray/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "5e0dfe2451bf022ed0dcacb657c39cef07bb4e7df43f1c95ae38372d71bcdf30"
  license "GPL-3.0-only"
  head "https://github.com/luynrs/justray.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e4605872d2cc587719ca3aa04d1d8a15b7c7fcd340c200edc286a7fb37dd958"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9432d34c698670af95bb0636b5069a894f1ed866a8c067fbd0923dfce14d6fb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9573aa65d1ee1cdb8c17b4e11989314260a9020cc5cf0d44c81d47ea44ea5c19"
    sha256 cellar: :any,                 x86_64_linux:  "99206c477083a94de50ca4cecd43560fe26a8f8570dfede56ca11fc743c37703"
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
