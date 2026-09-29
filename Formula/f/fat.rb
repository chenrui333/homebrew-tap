class Fat < Formula
  desc "TUI-based file and archive viewer for your terminal"
  homepage "https://github.com/scm-repo-mirror/Zuhaitz-dev_fat"
  # The unavailable upstream repository's release commit is preserved in this source mirror.
  url "https://github.com/scm-repo-mirror/Zuhaitz-dev_fat/archive/refs/tags/v0.2.0-beta.tar.gz"
  sha256 "dcb17302dac67d1e271cd0eb0d9dc6ffbce8ec1ea02e566ef4cc3590a583f884"
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

  deny_network_access!

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/fat --not-a-real-option 2>&1", 1)
    assert_match "Unknown option: --not-a-real-option", output

    output = shell_output("#{bin}/fat first.txt second.txt 2>&1", 1)
    assert_match "Multiple files specified. Only one file can be opened at a time.", output
  end
end
