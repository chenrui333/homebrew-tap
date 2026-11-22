class RatCommander < Formula
  desc "Dual-pane terminal file manager with a built-in viewer and editor"
  homepage "https://github.com/dividebysandwich/rat-commander"
  url "https://github.com/dividebysandwich/rat-commander/archive/refs/tags/v1.9.10.tar.gz"
  sha256 "fff7e1fa54265ae6b224bace956d813ce3fe3a2f8825729a1ec66b203252be29"
  license "GPL-2.0-only"
  head "https://github.com/dividebysandwich/rat-commander.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  on_linux do
    depends_on "alsa-lib"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink "rc" => "rcedit"
    pkgshare.install "packaging/shell/rc.sh", "packaging/shell/rc.fish"
  end

  test do
    # FIXME: Upstream does not expose a version command; add a version assertion when available.
    (testpath/"disk.img").binwrite("rat\x00commander")
    assert_equal "rat\x00commander", shell_output("#{bin}/rc --image-read disk.img")
    assert_match "image-read missing.img:", shell_output("#{bin}/rc --image-read missing.img 2>&1", 1)
  end
end
