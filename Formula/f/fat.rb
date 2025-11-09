class Fat < Formula
  desc "TUI-based file and archive viewer for your terminal"
  homepage "https://github.com/Zuhaitz-dev/fat"
  url "https://github.com/Zuhaitz-dev/fat/archive/refs/tags/v0.2.0-beta.tar.gz"
  sha256 "1a5cd3f2d12ca46dbe400e8f685eb8ecc34f269693373a398e8530a3abb5d097"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "f36391377c958696e3dd4b0abd029336a586a3d5346a537d5888f21db02ec625"
    sha256 arm64_sequoia: "bd7235b7d62c3db8f2b99207ae1893e5cd1e95ab10a434258d9e17d88896f9cc"
    sha256 arm64_sonoma:  "8333f0478e93d2e23c74d67973506124e4c31c9f8de2b466977da331c4cde219"
    sha256 arm64_linux:   "1135dce94f49aa19aa977c39b3bb51fea016a4ce3bb31168ad80e6bbec5e2143"
    sha256 x86_64_linux:  "8a4c8b9bda3cc52fc51b1b0013d8c7bb6337a0a2b86409eb0050cf780bfc3760"
  end

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
