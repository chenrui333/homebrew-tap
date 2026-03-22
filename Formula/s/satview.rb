class Satview < Formula
  desc "Terminal-based real-time satellite tracking and orbit prediction application"
  homepage "https://github.com/ShenMian/tracker"
  url "https://github.com/ShenMian/tracker/archive/refs/tags/v0.1.18.tar.gz"
  sha256 "6c6c82ed9fd04a8509424c3dfb932e938f47b6e30c29a128855f305804bb4496"
  license "Apache-2.0"
  head "https://github.com/ShenMian/tracker.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args # artifact would still be `tracker`
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tracker --version")

    output_log = testpath/"tracker.log"
    pid = if OS.mac?
      spawn "script", "-q", File::NULL, bin/"tracker", [:out, :err] => output_log.to_s
    else
      spawn "script", "-q", "-c", bin/"tracker", File::NULL, [:out, :err] => output_log.to_s
    end
    sleep 2
    Process.kill("TERM", pid)
    Process.wait(pid)
    output = output_log.read
    assert_match "\e[?1049h", output
    refute_match "No such device or address", output
  rescue Errno::ESRCH
    output = output_log.exist? ? output_log.read : ""
    assert_match "\e[?1049h", output
    refute_match "No such device or address", output
  end
end
