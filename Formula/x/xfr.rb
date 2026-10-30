class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "dabff0fffc4212b3a866c7c7f828ee6830deb4a37b5fade144eba84c3c806be7"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "288b93f2406679b8c4af52fb14600862e4b3c9541bc95432d8e62dbf6afc9221"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d2f8b5433a4b7f2074a1347909c48b37e5f87563badd1a4b8a66d2ff9800978"
    sha256 cellar: :any,                 arm64_linux:   "79815e70a561481a28c0c77a92cda1068e2adf94465543941ab7d44cfa6b8525"
    sha256 cellar: :any,                 x86_64_linux:  "ea86781d0b31c8d55c3cf2e3e3a4427fee64389e400ee3e894d5dd47b9be91dd"
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
