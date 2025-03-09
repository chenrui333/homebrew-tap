class QuicsshRs < Formula
  desc "SSH over QUIC"
  homepage "https://github.com/oowl/quicssh-rs"
  url "https://github.com/oowl/quicssh-rs/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "1e1b98e67598e2ee1c3704c75072b9e120a0ec21f70ad2cd1d2c5918d68a57b8"
  license "MIT"
  head "https://github.com/oowl/quicssh-rs.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quicssh-rs --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"quicssh-rs", "--log-level", "debug", "server", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "[server] listening on: 0.0.0.0:4433", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
