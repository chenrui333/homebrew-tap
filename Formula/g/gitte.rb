class Gitte < Formula
  desc "GTK4/libadwaita Git client for the GNOME desktop written in Rust"
  homepage "https://codeberg.org/ckruse/Gitte"
  url "https://codeberg.org/ckruse/Gitte/archive/0.7.2.tar.gz"
  sha256 "5c2448e54d2c11070b09eb13bedc989607d1b0b7614ba1778afc7ca8cc3b2da7"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/ckruse/Gitte.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "1c24f1ada3a6351dba3b964a189737b6294c7e06ccfd77bd8821db2bd40d9a26"
    sha256               arm64_sequoia: "9212f7941a5fcf71afe51a4d8cb261ad9e990aaee40cbe7d706e4cdcbc18650b"
    sha256               arm64_sonoma:  "a29294a2fadc7ff519c52bb33cedde50e0e64ed85078add6390b491f418ea2e4"
    sha256 cellar: :any, arm64_linux:   "f2f38c2f5c8c6c70b2f357ef2af89e862d869221d3102bc3b42ee0c7731e9d21"
    sha256 cellar: :any, x86_64_linux:  "af5806fd969d577937cf5956b21082eda9ce009bb0631e2ddab80dcc74f557e0"
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
