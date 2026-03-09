class Fat < Formula
  desc "TUI-based file and archive viewer for your terminal"
  homepage "https://github.com/Zuhaitz-dev/fat"
  url "https://github.com/Zuhaitz-dev/fat/archive/refs/tags/v0.2.0-beta.tar.gz"
  sha256 "1a5cd3f2d12ca46dbe400e8f685eb8ecc34f269693373a398e8530a3abb5d097"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 arm64_tahoe:   "7ced12f890929c85a7a3dcc8b304bacbe07fd0b8650d96bbd406f6faa32130e8"
    sha256 arm64_sequoia: "e0ce26ee8f47d994b128e4541f72d8ab0287faa5ad0da1f020edf67ab6f0133e"
    sha256 arm64_sonoma:  "9dba4fece3751855aa73fdd7f93f49ee564e26d49e22ff3a35ad001dce30a73e"
    sha256 arm64_linux:   "48132202410303d8d93cde2ff8f6b7ddf474b97696a187fb0b55c0536b4738ac"
    sha256 x86_64_linux:  "f4d857365b358c53bb3d5ffb73a3127a62ec802619dc5e2331e8330365d1f2f4"
  end

  depends_on "libmagic"
  depends_on "libtar"
  depends_on "libzip"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
