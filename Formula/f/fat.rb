class Fat < Formula
  desc "TUI-based file and archive viewer for your terminal"
  homepage "https://github.com/Zuhaitz-dev/fat"
  url "https://github.com/Zuhaitz-dev/fat/archive/refs/tags/v0.2.0-beta.tar.gz"
  sha256 "1a5cd3f2d12ca46dbe400e8f685eb8ecc34f269693373a398e8530a3abb5d097"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 arm64_tahoe:   "26d5acbc183276a023f96e392b153bd23980ef0c8d3fe6a63e655e559378602e"
    sha256 arm64_sequoia: "da25bf1ad484a021511dd31d8d62c212ce3fff7ccf6f4a58ce11e7f531b28cea"
    sha256 arm64_sonoma:  "c9bf440388ee39139dadf922c8ffae1d5b859961f11f674537212486a1eb397f"
    sha256 arm64_linux:   "9a7c33b27e8d7740f0ee420ea66a70cdb015ff4b316d183fe84b53d5f815954e"
    sha256 x86_64_linux:  "bce4f97f556c56bc0e074ebaa9e69b2e9ea46747b60c757d8cbedcbfb32bd1a1"
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
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"fat", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output

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
