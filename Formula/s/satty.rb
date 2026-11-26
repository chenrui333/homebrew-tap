class Satty < Formula
  desc "Modern Screenshot Annotation"
  homepage "https://github.com/gabm/Satty"
  url "https://github.com/gabm/Satty/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "33ab13767010663762165f0130df9f11edf133e28e49f13bd7bc45cb02516a79"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "f0ffc5b3ed0557d4b9aeb0a371e4a79c03cf0450277d44764e0a3eefb6de71e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2754b9b86bc4f359bd9acb902630db5d031cb2ad82de3017a5a2600587c9e64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a58631d16eac3cdc270de13a17dd32e0dd3df43284027bfb45972b201e4c65be"
    sha256 cellar: :any,                 arm64_linux:   "303a4f60e58d84f1fbd2e5f4d5e34bceaec8b5cb8bceec05282605b3bbe8ff66"
    sha256 cellar: :any,                 x86_64_linux:  "5e1ad1816fbcc4d17b562ad0df12ecca6f48db50a1d02794657e332f614db281"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "libepoxy"
  depends_on "pango"

  on_macos do
    depends_on "freetype"
    depends_on "gettext"
    depends_on "graphene"
    depends_on "harfbuzz"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"satty", "--version"
  end
end
