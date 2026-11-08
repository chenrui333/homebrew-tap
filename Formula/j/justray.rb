class Justray < Formula
  desc "Terminal VPN client"
  homepage "https://github.com/luynrs/justray"
  url "https://github.com/luynrs/justray/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "5e0dfe2451bf022ed0dcacb657c39cef07bb4e7df43f1c95ae38372d71bcdf30"
  license "GPL-3.0-only"
  head "https://github.com/luynrs/justray.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5d13133a153e76933a9653d2a586354773a2e1a0a0186e993e5753d945610e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39fddc1fc82f506fe28308b2f1423267137146a662b258a74282f7e9fc965aaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89f01af9009b4daf4027e012dd4e5db33c2f5c55b6bc67c8806b78b979559c62"
    sha256 cellar: :any,                 x86_64_linux:  "c163b3cb8c5a36ee3390a57743c0285fc171cfe0bbc2d2b4e360f5ed449c95f8"
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
