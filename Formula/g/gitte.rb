class Gitte < Formula
  desc "GTK4/libadwaita Git client for the GNOME desktop written in Rust"
  homepage "https://codeberg.org/ckruse/Gitte"
  url "https://codeberg.org/ckruse/Gitte/archive/0.8.0.tar.gz"
  sha256 "05bceaab66afe3e7147bba78632d31c9e96d379af8d1b5150f523fe76d511250"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/ckruse/Gitte.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "8510fe0dbf40ee2769a34c570b43a788280d5de1edaec68607df4da5f7e9a1f9"
    sha256               arm64_sequoia: "fed0ce908b269d3293da1eca127eb2342aaf083e59d978e0cc12103f3e0d6e7f"
    sha256               arm64_sonoma:  "664d6ea0a4cb59cd406ac2ef4942448af511e11a74a18f142fcbfae137732ffd"
    sha256 cellar: :any, arm64_linux:   "9c3c2ed05ce2d2ee0905b63b415a9ded0df06ab642e5be6c078c2757f9cf1ed9"
    sha256 cellar: :any, x86_64_linux:  "56c2d47bdc9d0219ac28bcae61306c205f9a1e0bf919bf129a5f305b6e8ad238"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "harfbuzz"
  depends_on "libadwaita"
  depends_on "libgit2"
  depends_on "pango"
  depends_on "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "meson", "setup", "builddir", *std_meson_args
    system "meson", "compile", "-C", "builddir"
    system "meson", "install", "-C", "builddir"

    compiled_schema = share/"glib-2.0/schemas/gschemas.compiled"
    rm compiled_schema if compiled_schema.exist?
  end

  test do
    assert_path_exists bin/"gitte"
    assert_predicate bin/"gitte", :executable?
  end
end
