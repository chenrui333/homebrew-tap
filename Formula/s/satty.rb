class Satty < Formula
  desc "Modern Screenshot Annotation"
  homepage "https://github.com/gabm/Satty"
  url "https://github.com/gabm/Satty/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "604d7b2624db39bf8817d027f1eee1675edf4d3cffbf569936adeaba181700c7"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "d86c0636749159824e1c954aaf2996b4e3b52ffb725ec519c445d583e134ef3a"
    sha256               arm64_sequoia: "af6ab44507d6738522574831f8c7222cd13dfe7a345a7e89f1832d54ee749253"
    sha256               arm64_sonoma:  "9a7383647d64d8e1636a684682d68c0476f8c385a680eb8f3b3552e11406a817"
    sha256 cellar: :any, arm64_linux:   "955eb3606c8e75a5c20b77dc011bcb61db236298ad6c4cadbe86816a90f433d2"
    sha256 cellar: :any, x86_64_linux:  "5b20cb715eaea99a5a38c1381e8976b23149d8263ea85166dcf7cc631d0d3877"
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
