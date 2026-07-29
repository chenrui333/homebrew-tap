class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.23.tar.gz"
  sha256 "020869bff0e2311a5e05bf15d754133c8b4892d2f7f8351f188853bc54dd986c"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72a97a1582c951c32057dba20d9307855cad1830f1f934c2d95958e919aed06f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea9f9daf5d5c4ff5776b0109c6f35da516cc8d2260643b6dc010e4817148dcca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d24ef322618165c12223f66c57e395e726a863ae743ae7142efe1a904cca548"
    sha256 cellar: :any,                 arm64_linux:   "945ae8ea051764a31bf0182f52a124ff19dc945c0bf880d2faa2a6dfcea82faf"
    sha256 cellar: :any,                 x86_64_linux:  "d1db3f9d6776e4c43e38280ca9a05a8ba43fc40e39fefd06b20f5c834c1864f3"
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
