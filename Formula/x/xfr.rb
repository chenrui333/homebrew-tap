class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "41884d777070ce900324c655ead124984f358699e8ba7bcafe1977515c5c0d40"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "effe72195f9e4f34734379eee2eb536744d614624506e6f14c1d7ecc7ed0b69e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6619a2a62e981d8d95b1e13373b9f7fea6f676295c89f68ece61d24ea8bd01f"
    sha256 cellar: :any,                 arm64_linux:   "b507d3e1484cfab35d4977c8b2bcea4db0844117a3468c970b8c0950d39818af"
    sha256 cellar: :any,                 x86_64_linux:  "b46c112bc14c458ac3a17cf882f6ea13e163a920750a4e2b9579dd014d4f8d6c"
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
