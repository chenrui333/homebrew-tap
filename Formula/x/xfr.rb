class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.22.tar.gz"
  sha256 "4208791c98c79761460b9b7fc96444560fb50d59e6b8dfe4fb12cfeb4ce75686"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b68a24c78605f46afdba5d60465cafe5ca2fcc4fb64597df393378cffbae8e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d78a032d7f7f7d70b0a4d8319267db24af0d7b60cd3d459b19700db03c83e415"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2930e725ec94071f1e0dccb486fef047b30a6186b72e4959b8835d7671cb6fb9"
    sha256 cellar: :any,                 arm64_linux:   "63ce717d9a60a4ad0151757d3c8a0b4993669feb4dd54af584b5ae83f62ab34f"
    sha256 cellar: :any,                 x86_64_linux:  "259de2d86c632fef6f113b092d71413ee8210ac4462c3862376aac189af82d2f"
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
