class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "41884d777070ce900324c655ead124984f358699e8ba7bcafe1977515c5c0d40"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5d3a94d71b9674b53d93017bafafd3c86345f8e85433e0c6916ac821e66aee2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "125e8d1454f68e199305227812bd9b8c2b978ecae5cc6e2c8abb2712af2b3733"
    sha256 cellar: :any,                 arm64_linux:   "82601e9ee5c10cd12c3d9754e83281aeefce100506203c7289b7cafa394ebc97"
    sha256 cellar: :any,                 x86_64_linux:  "532b23cd3ef9e1b40f39840b464989081039da4babe28be1c06a4b8bba0f4049"
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
