class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "220130f776a5ea90248964c42ba8194461ebc3eee3eb715ad7e24158d65ea54d"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af473e2e611190f4abdee161133d890efb1022847f5eaad28ad8251e0c4e52d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e744058eacfac8c9fcbe1eac79399cb7190610364bdbc66b8c0f469a87bfbcf"
    sha256 cellar: :any,                 arm64_linux:   "87c2f8468a6eb49d85f9a5082f083057fd42394ec6c098518908a3336c7c3c55"
    sha256 cellar: :any,                 x86_64_linux:  "a9033eef99f892f5d497edb02d8cc69574a63a606a493c9725cba435537ae4b6"
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
