class Fat < Formula
  desc "TUI-based file and archive viewer for your terminal"
  homepage "https://github.com/Zuhaitz-dev/fat"
  url "https://github.com/Zuhaitz-dev/fat/archive/refs/tags/v0.2.0-beta.tar.gz"
  sha256 "1a5cd3f2d12ca46dbe400e8f685eb8ecc34f269693373a398e8530a3abb5d097"
  license "GPL-3.0-only"

  depends_on "libmagic"
  depends_on "libtar"
  depends_on "libzip"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"fat", "--help"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      (testpath/"test.txt").write("Hello, Homebrew!")

      output_log = testpath/"output.log"
      pid = spawn bin/"fat", testpath/"test.txt", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "[NORMAL]", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
