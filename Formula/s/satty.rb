class Satty < Formula
  desc "Modern Screenshot Annotation"
  homepage "https://github.com/gabm/Satty"
  url "https://github.com/gabm/Satty/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "eee18b5f9eabf164da69c7e6e916c98afb78dd296d83e28bb96d9f9636a5fe36"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "cec0c06418ca5d1c28d887c6afdf8133a4ac33c52e331c71a890dc1628d8f6b4"
    sha256               arm64_sequoia: "22d7258df1009c6afd5140300657213eb1c97d720475e422f8abed342eb72153"
    sha256               arm64_sonoma:  "c90c91a0fdb20952bfc8accabb5d9a11bd7f8e7fb9a34bdd649281cb06b82b2a"
    sha256 cellar: :any, arm64_linux:   "912a738de98a4becb7a126babc23a40eda387c8376242fe7eb8446907986ccf0"
    sha256 cellar: :any, x86_64_linux:  "f1b21c4f62889ebc6d11f7b82b65328e2ece6dc8d8d374c0a3a254c499545ae0"
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
