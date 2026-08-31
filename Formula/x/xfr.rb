class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "cd92f39a0ba5ecb574415f3075c5f76b1e596e0fd5db42163b7885aebccad93f"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73451cf6402209a4ba3443b040dc2b68dbf3b9bcfbe083762649a202d0ce4cd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ad70bdc967fcbe6babe4c10bda96f94749a989cc774ea24d17159fedc9d31e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d86e777947a454706b8a29048e436d5bcf40890e55bbda22448c13f031a2a5cc"
    sha256 cellar: :any,                 arm64_linux:   "d13ec249bcf82ed8b06958372756fdbab19a895206521ff7ca440b785a5d614c"
    sha256 cellar: :any,                 x86_64_linux:  "9d15c08587d8eefd406a956b8cabcc448799b440b9557a108dcb8f426349f46a"
  end

  depends_on "rust" => :build

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
