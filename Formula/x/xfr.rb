class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.24.tar.gz"
  sha256 "b5d74029e0ceaf029d15dee739f72a49c0b128389d3712c3c4b50d091f6bd480"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46d556bb98047b61dd1c0e0a8f568916d5ab0642fa249b3b5b6d6183fd8f8b7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "221952c4afbc4169ffafd347e7ff039db6f4f9cfee4261817fcd270ab3cf4693"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3216011f3a5bf1a38a157bf2903824583ede118908ce34ba90f2874e97311744"
    sha256 cellar: :any,                 arm64_linux:   "e87058811beeb931272b09812151839ed58e94d851a396f74ed89f9da925b205"
    sha256 cellar: :any,                 x86_64_linux:  "c540cb4704911615e42b5ae50adea69508e08d0022495fdc0c0167cec7fccc7a"
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
