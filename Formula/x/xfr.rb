class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.20.tar.gz"
  sha256 "5e186753cfa67fd6ea4c0a6e9fe87e7232969c223efa68ee45f49ca8b06208c0"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dc3c02cb478cb60ce95dec4e415b0fc2e19da67b1d18fa8097435cdde33802d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df5d739fa67949b8c0b23d709de17dffbdd066564b3a555c841030844b112ea1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7a4f966e6ce5e112ff4fb12ecc737e711ad0ffb66f65cd13247e0f8af1c800f"
    sha256 cellar: :any,                 arm64_linux:   "a7563a29b09c21710c4c7a8eae82866ed0168a70a4d31a3d80328a23c6812859"
    sha256 cellar: :any,                 x86_64_linux:  "e9af25f5d3e4d3fafa8f2cb478bc49784841248563716426f3a35bef8ef6bc1b"
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
