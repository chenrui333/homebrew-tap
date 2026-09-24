class Gitte < Formula
  desc "GTK4/libadwaita Git client for the GNOME desktop written in Rust"
  homepage "https://codeberg.org/ckruse/Gitte"
  url "https://codeberg.org/ckruse/Gitte/archive/0.10.1.tar.gz"
  sha256 "e4e639f656de0a5cae87b5e95d18e8025c0eb21a3a182f8fb7c74803a5489cb8"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/ckruse/Gitte.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49f2ce590b049d3bcb522f1d6f30efc99078e15404b0d3ea17346d9aa7642c11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0359ab0bedaf26878de9da02663c586e66fd7ca00f9f232ba0eb39320cec48c2"
    sha256 cellar: :any,                 arm64_linux:   "4dbfc7091213c28c38870eec239c31fbe7e49acfa7aef24d70af61e1a790d6b4"
    sha256 cellar: :any,                 x86_64_linux:  "c782cc6403155716e11e64c93d222f9b9dc94ebdc66d4f6612785b3edeb4b737"
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
