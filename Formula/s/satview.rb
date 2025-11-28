class Satview < Formula
  desc "Terminal-based real-time satellite tracking and orbit prediction application"
  homepage "https://github.com/ShenMian/tracker"
  url "https://github.com/ShenMian/tracker/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "da59c25ac39f6cf119df37c41161190bfd2260157b65ff3a9aed1409373e45b1"
  license "Apache-2.0"
  head "https://github.com/ShenMian/tracker.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args # artifact would still be `tracker`
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"tracker", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Satellite groups", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
