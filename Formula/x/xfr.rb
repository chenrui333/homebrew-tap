class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "220130f776a5ea90248964c42ba8194461ebc3eee3eb715ad7e24158d65ea54d"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "500fa7d8edb7e81532be3ce31fbe5d3fce885a60c116bf883c5b5d7ee4178ed8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bf7273ea9165d43f658a8dba81c00345f9be4f41080b19b982a7730d4ca9d3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56fceef13b3b88e5e1481a0d42fb1395177d6dfcdf971cbce58d806ea1744fa0"
    sha256 cellar: :any,                 arm64_linux:   "053e337673957c1432cc3f94a305eea8fdc4b7adfc7972dd0afeea6eaae2f0e2"
    sha256 cellar: :any,                 x86_64_linux:  "34a81f839c6f860ea4260596ad932a7d70d223e40fa8c2e6d6a3874226effad9"
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
