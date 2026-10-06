class Oxicord < Formula
  desc "Lightweight, secure Discord terminal client written in Rust"
  homepage "https://github.com/linuxmobile/oxicord"
  url "https://github.com/linuxmobile/oxicord/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "eea5dcd301c14667167c31eeff83a97aba7132c76abd4cd72952693d79584369"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85442dfd211f657340e21fdddf94c2bdf3f0591775905a55e7e853d0f8be6ae8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d2097ebceb1f8b53d68ad89612bcd37ac97a00c194c33d530b6b7ee22e6945f"
    sha256 cellar: :any,                 arm64_linux:   "6a3ae5a188b73f5659941ccdd9dfab28cd4b7fe8cd0ce357873f18d78d4dd327"
    sha256 cellar: :any,                 x86_64_linux:  "3d01a4d2dfc5257a90eb6b802f12f39a4fafbb7fee946e711ee0a567787a3ebb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "chafa"
  depends_on "gettext"
  depends_on "glib"

  on_linux do
    depends_on "dbus"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # oxicord is a TUI app, so just verify the version output
    assert_match version.to_s, shell_output("#{bin}/oxicord --version")
  end
end
