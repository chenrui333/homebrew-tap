class Gitte < Formula
  desc "GTK4/libadwaita Git client for the GNOME desktop written in Rust"
  homepage "https://codeberg.org/ckruse/Gitte"
  url "https://codeberg.org/ckruse/Gitte/archive/0.8.1.tar.gz"
  sha256 "f6519e7935b75d0db51d0a426e4b6829d5852e7f83bb3fb9cc74399ad21cef86"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/ckruse/Gitte.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "e376feff3e9ef3e81e94cc0b8a76e749403cf038f6920b7620a63c6782369380"
    sha256               arm64_sequoia: "40b7900b48c614e40b77245aa5453fd814405a0ae78cfc757e34c780e0ae954c"
    sha256               arm64_sonoma:  "a728e0a04e395d902bc3d0a3f252035d4868f672cab8008c36e35e28a1fdfba8"
    sha256 cellar: :any, arm64_linux:   "e9bf9234b0d32ef686b6bd3f05e4cae7d32707faabb2a21dff3974e466162378"
    sha256 cellar: :any, x86_64_linux:  "0472c2a6c11932b0799d35bccd80a119721767687c9e15a268dc4ca8dbdfa0b9"
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
