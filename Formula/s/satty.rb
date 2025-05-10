class Satty < Formula
  desc "Modern Screenshot Annotation"
  homepage "https://github.com/gabm/Satty"
  url "https://github.com/gabm/Satty/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "9dc519e572982956db2e7165ab2931c19fe0e88db133a3776d4293ddcd13ca49"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "d993d087e35caba34db08977091b755d98b754efbf87a39d8829f4cf79de1588"
    sha256 cellar: :any,                 arm64_sonoma:  "207127a66880b6485862f171c0e8f602585a4493af9fd10f2e597c6a95aca0f3"
    sha256 cellar: :any,                 ventura:       "455cc9d24f1af5e2d9679bf736c8dead44c05a90780df830ac203473b7f8754b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94e144a0b7fa1dba00af5d3e634e989276be28d27eb56b47b0e92b37c31ea430"
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
