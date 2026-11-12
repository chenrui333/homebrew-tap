class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "9b974caec05289531ed5e713c0a2041c1f675c66c5be4f2ec4138b5b12e455d6"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ddc61830cb0091b5a7c5f546ff417abac7437399352c9f942d0fde47c521b66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20eca7562cd4ca64fe84044efc6148789d578ed8b6d168a1f281f625b0c5f194"
    sha256 cellar: :any,                 arm64_linux:   "8be21c4fe5ce72416de0a37f83292cbe7f59d1b1ebcec343781d3e3203a2bf55"
    sha256 cellar: :any,                 x86_64_linux:  "62f0149ec21f8b65065281ab5509893d4bddfd57e9d1421334a0f1f719678fe4"
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
