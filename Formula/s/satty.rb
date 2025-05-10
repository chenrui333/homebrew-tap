class Satty < Formula
  desc "Modern Screenshot Annotation"
  homepage "https://github.com/gabm/Satty"
  url "https://github.com/gabm/Satty/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "9dc519e572982956db2e7165ab2931c19fe0e88db133a3776d4293ddcd13ca49"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "7d1ad446659d1090224fff7bc5924b6415a4c67ac02bc6e22bae1aa3e9b41f6f"
    sha256 cellar: :any,                 arm64_sonoma:  "213baf964a79752912d9514295e9d1e90bd2e88f0c3c8e530ef92b8b5b1c1e5b"
    sha256 cellar: :any,                 ventura:       "9c398177c26a6d4f4d861dbb652bcbfa0971958b44867e579f7108f5e1d7e536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20c646c9ec18756b11eb4c6b17f09f4eb83586a09f4a6471268fe670d5f6a8e0"
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
