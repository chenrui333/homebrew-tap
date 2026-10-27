class Gitte < Formula
  desc "GTK4/libadwaita Git client for the GNOME desktop written in Rust"
  homepage "https://codeberg.org/ckruse/Gitte"
  url "https://codeberg.org/ckruse/Gitte/archive/0.11.1.tar.gz"
  sha256 "da2072f7c0626e10573d4cc9c5661b9ef55b0d50283263f90191b15f036908ca"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/ckruse/Gitte.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9071f57a3b42dcaa4941367632267771374d8f76988b8a5fdd9c7c5767c29ae1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adb837953cf8973cb981a7614607ded067f5cff8562628d0b332f46897e10329"
    sha256 cellar: :any,                 arm64_linux:   "002b95a81144bd35eb9da8636ad6b6a22fd43e1b8cc1ac77c8d20c332d3312ad"
    sha256 cellar: :any,                 x86_64_linux:  "3253b34a58c906eaa8bd2be252b117ae471a22d3d4a14306bb5ae2af31879617"
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

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "meson", "setup", "builddir", "-Dcargo-home=#{ENV.fetch("CARGO_HOME")}", *std_meson_args
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
