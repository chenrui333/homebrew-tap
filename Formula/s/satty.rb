class Satty < Formula
  desc "Modern Screenshot Annotation"
  homepage "https://github.com/gabm/Satty"
  url "https://github.com/gabm/Satty/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "36ffbea973fd844d92998f1d5aed53c779692e956ed07490d324812223eab4bd"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "e2224070983790bf63da7e81fa39d6f93454e44901481272d926a06bd4c20f28"
    sha256 cellar: :any,                 arm64_sonoma:  "09ea7c97bff0da752e2e6071e505792cefe9101dc8b5fbc5ddc8c5e97e855353"
    sha256 cellar: :any,                 ventura:       "1f3fe2166c9b0e7b5c515b8ef97d272801c5b6b8e6c1f429c7cb90f0acca1f11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ded338edf1c6289d1b2fdee30149adce3a68417285402bbc912577d6abaf6d36"
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
