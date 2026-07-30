class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.24.tar.gz"
  sha256 "b5d74029e0ceaf029d15dee739f72a49c0b128389d3712c3c4b50d091f6bd480"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbdb4a0c43585355a68f98c909ef9bdb330acd8141dafe4afb5d15367d9bc0c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bcfaec746f07951ea0138ebccdf3b3f4dca5650c85f4f1c1ee7fe6ad91d8803"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "786e65437cc8ab0e852ad927ba9a7fed833f76f15631d3ea61f7eb98cfd1aee7"
    sha256 cellar: :any,                 arm64_linux:   "ea43cec119a0501622f3db7191f7760c37374cc08072f053b8de7d22f1ed1c39"
    sha256 cellar: :any,                 x86_64_linux:  "a03bb3efde2cd38df98ba192d12231952376403a2fd1e3652b3f4d448af653e5"
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
