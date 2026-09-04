class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "220130f776a5ea90248964c42ba8194461ebc3eee3eb715ad7e24158d65ea54d"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0904867f1bb69f2303db2244c22d50ae39d65bb12cba6074bb99f21d01f756f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1049d7071eeebc41ee36bb4a7d73b40a196c18abb1768160cf6d024b5098788b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b264c5debc97bb63edbc55a33b8765898de9911855e43f3db3a166e192dcb35b"
    sha256 cellar: :any,                 arm64_linux:   "93a724b72baae51d364bd35f23857869489a3be4539b937dacb8f21c9774a756"
    sha256 cellar: :any,                 x86_64_linux:  "151c8443315a3279dadd9cd62996030b956a8a7ef928e36d92e2b95f45b04d3d"
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
