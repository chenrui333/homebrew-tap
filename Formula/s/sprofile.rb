class Sprofile < Formula
  desc "Blazingly fast TUI application for viewing your Spotify listening activity"
  homepage "https://github.com/GoodBoyNeon/sprofile"
  url "https://github.com/GoodBoyNeon/sprofile/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "453464c1b1a7d25bf4e75ea7222e5cf2aab766469adb0afab8d8f5d999ea50c6"
  license "MIT"
  head "https://github.com/GoodBoyNeon/sprofile.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output_log = testpath/"output.log"

    pid = spawn bin/"sprofile", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "* * Welcome to Sprofile! * *", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
