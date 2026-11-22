class RatCommander < Formula
  desc "Dual-pane terminal file manager with a built-in viewer and editor"
  homepage "https://github.com/dividebysandwich/rat-commander"
  url "https://github.com/dividebysandwich/rat-commander/archive/refs/tags/v1.9.10.tar.gz"
  sha256 "fff7e1fa54265ae6b224bace956d813ce3fe3a2f8825729a1ec66b203252be29"
  license "GPL-2.0-only"
  head "https://github.com/dividebysandwich/rat-commander.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "7510a5506acdc16168150023f0e19dfd47679cb7f71a7960ac4555551f8ab8aa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86884d5a9e768673ef32af2271b430e92d4e7e3456483edbe6cdb09db15af2bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6abafb706ac103ec6cc70fd89cbb7131bb2ddea90db6cc0a34617cda94119e20"
    sha256 cellar: :any,                 arm64_linux:   "05cda6a0bead339d2153e0aed26a2ec8cfdb89e8686599fe2006dff3691d5eeb"
    sha256 cellar: :any,                 x86_64_linux:  "c58a48cade9a59f677aee391fadeb5530f5aaa29b7ba93e4b39968583ba98d95"
  end

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
