class Satty < Formula
  desc "Modern Screenshot Annotation"
  homepage "https://github.com/gabm/Satty"
  url "https://github.com/gabm/Satty/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "78b3fd048afe13c6850c6761d308e3e4e3e7d235d6218859aab2947570f08fda"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "e222dd181355455286cf022a3a2e23101d2d2528d6ef0d6f36b61ab36ec5eca6"
    sha256 cellar: :any,                 arm64_sonoma:  "258934b7ffec1ae332c2c04fc9d4dce80f2b7cd13fc60a9e5df94b487a7431ac"
    sha256 cellar: :any,                 ventura:       "48144014be4e066b7429dfff692fd15629fe6cbd5ec4a5bf0296f9f0188e24f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86dcc4de685495e2777bc8a17dcb706236a24c1405279fdeb5262e271565e433"
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

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"satty", "--version"
  end
end
