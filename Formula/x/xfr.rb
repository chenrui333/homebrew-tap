class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "3f4d5a6ad611713466c2e273bad33e0c3f6f6f455611f253027a5ee9d72bbbb0"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6278d1d9168ee4141c1f87c9f84fe9e8f2e91db1b71e55461d50fab8b0aec0f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d85e16941e19e916c2ac2853ce705542c0de38adaa5b1f5a46183b8f745eb46"
    sha256 cellar: :any,                 arm64_linux:   "69440fe25e5e0f5b9153a4790b152f3fb8d7d3d69ae693a4b68dbd2f500f3c3e"
    sha256 cellar: :any,                 x86_64_linux:  "4039eaebc210a59181426afd7ac5175e51d45fe5b484312b4bcf1daa79d6836b"
  end

  depends_on "rust" => :build

  # xfr is a network throughput tester; the test runs its server and client over loopback.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"xfr", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xfr --version")

    port = free_port
    server_log = testpath/"server.log"
    pid = spawn bin/"xfr", "serve", "--port", port.to_s, "--ipv4", [:out, :err] => server_log.to_s

    50.times do
      break if server_log.exist? && server_log.read.include?("TCP listening")

      sleep 0.1
    end
    assert_match "TCP listening", server_log.read

    output = shell_output("#{bin}/xfr --no-tui --json --quiet --time 1s --bitrate 1M " \
                          "--port #{port} --ipv4 127.0.0.1")
    assert_match '"duration_ms":', output
    assert_match '"throughput_mbps":', output
  ensure
    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
