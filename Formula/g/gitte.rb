class Gitte < Formula
  desc "GTK4/libadwaita Git client for the GNOME desktop written in Rust"
  homepage "https://codeberg.org/ckruse/Gitte"
  url "https://codeberg.org/ckruse/Gitte/archive/0.11.0.tar.gz"
  sha256 "b2cb52b4b2b9a8399cafaf03812fd25a1ee16dc7293525bd462e48795eb247cf"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/ckruse/Gitte.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b070af7e47131444d8be01b75b593c4cc8243486e89324d49b23700d148faeb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfc14d2def1db476092914f85f5035cdd903f719cca6834f04217fade0f20a74"
    sha256 cellar: :any,                 arm64_linux:   "79a6392fcd8c11842f5a8a56044cd86b671f8f66334bea29f7a1e8e98144fae1"
    sha256 cellar: :any,                 x86_64_linux:  "11e2a7a3ec732e1988d0a5c9979d558cb669ee72f8d3f3742b35439cfa69e06c"
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
