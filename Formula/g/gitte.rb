class Gitte < Formula
  desc "GTK4/libadwaita Git client for the GNOME desktop written in Rust"
  homepage "https://codeberg.org/ckruse/Gitte"
  url "https://codeberg.org/ckruse/Gitte/archive/0.8.0.tar.gz"
  sha256 "05bceaab66afe3e7147bba78632d31c9e96d379af8d1b5150f523fe76d511250"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/ckruse/Gitte.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "eca037ad2bb2a5af5646d92d3eaf04c294e86a49c0e687edfe0ecef941934adb"
    sha256               arm64_sequoia: "f318004b2a10ccb23acbc7f987e5f9f12a99c26318911c3d0b7024a3f3655771"
    sha256               arm64_sonoma:  "d39f950259f420aaa3656e779806f7eb8fa4dc7e397b051ff1bc111a50b50e74"
    sha256 cellar: :any, arm64_linux:   "a4420940835b0511c2b95f5b3c911821c6e7588c2a34bbf780124df297d1f976"
    sha256 cellar: :any, x86_64_linux:  "2ecfbe1af0b55d1c626eaf85dbedb6bad432672523ee99cb2d5ea9d1669ff6e3"
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
