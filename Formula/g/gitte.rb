class Gitte < Formula
  desc "GTK4/libadwaita Git client for the GNOME desktop written in Rust"
  homepage "https://codeberg.org/ckruse/Gitte"
  url "https://codeberg.org/ckruse/Gitte/archive/0.9.1.tar.gz"
  sha256 "5ae0fedc6925fd83f51387da4b170d954379eba0e85291dcfe54319dfc12111c"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/ckruse/Gitte.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "7e1b955113b711a14c70a1a21c2f59a2291e86f8d39fe16db41227e68ab9206e"
    sha256               arm64_sequoia: "bb5eaa9cae8711310f7a620dcfe9c63c2936b675afb72480be02133d3073c078"
    sha256               arm64_sonoma:  "3af2abff0970abd6b6ff3208aad4aaed392553f27436161582216d9c4629e060"
    sha256 cellar: :any, arm64_linux:   "2e93272f6edfe7685a28a54931c59045ce4592bf02909ea275b97ed26f629133"
    sha256 cellar: :any, x86_64_linux:  "90bb68f336ab3bdebbc9671c589c21d67ad8ffa0f6faa65403622fa01b992b3e"
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
