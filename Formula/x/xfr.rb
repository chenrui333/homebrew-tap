class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.14.tar.gz"
  sha256 "9cf401397975a883f5e1c1c4e48bd7704acaafe099907f3c6ffbb1f25f2ee09a"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e999da4bb047d9314f3e7c671c35fa691f25bae388497f56422ae806e6731478"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80a92ac01cfa0f6c5b973c96e8fc5da5a88bf652f944a07f17b3f3609867e862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3da45106715a2843ab707a9d54c66526573c8dea678037d10190ef2f033f4308"
    sha256 cellar: :any,                 arm64_linux:   "1152dd89f7f0df4bb8f1ab0a1dcb05de220b617e2b4ee9b878bf637dd357c618"
    sha256 cellar: :any,                 x86_64_linux:  "d48b5054ef4a0e1f63448f037296647df247bd669a7e5c83a6a13d66db59a41b"
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
