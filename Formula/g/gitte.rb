class Gitte < Formula
  desc "GTK4/libadwaita Git client for the GNOME desktop written in Rust"
  homepage "https://codeberg.org/ckruse/Gitte"
  url "https://codeberg.org/ckruse/Gitte/archive/0.9.1.tar.gz"
  sha256 "5ae0fedc6925fd83f51387da4b170d954379eba0e85291dcfe54319dfc12111c"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/ckruse/Gitte.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "486865042a23e7bd205af879a1cd6e380ceea02ec940596b71a1c06d55007148"
    sha256               arm64_sequoia: "f6bad47044033d29f2aa4854986d8bfbb777cf6b70078d3040e54e4a83eddb00"
    sha256               arm64_sonoma:  "1d19399c914cb900e77fad7ea313be754dac2e84fa3a3e2707e15b023be11089"
    sha256 cellar: :any, arm64_linux:   "7fd97b47ccaca367b8e76ebf2a27f1effc91bd615fb93bbbfae276789a912343"
    sha256 cellar: :any, x86_64_linux:  "8aa908db2d8384db53db55207ecefdd3e04340c4aa067df5fb7bde5f92b9d0bd"
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
