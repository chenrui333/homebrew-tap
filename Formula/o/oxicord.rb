class Oxicord < Formula
  desc "Lightweight, secure Discord terminal client written in Rust"
  homepage "https://github.com/linuxmobile/oxicord"
  url "https://github.com/linuxmobile/oxicord/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "eea5dcd301c14667167c31eeff83a97aba7132c76abd4cd72952693d79584369"
  license "GPL-3.0-only"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "chafa"
  depends_on "gettext"
  depends_on "glib"

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # oxicord is a TUI app, so just verify the version output
    assert_match version.to_s, shell_output("#{bin}/oxicord --version")
  end
end
