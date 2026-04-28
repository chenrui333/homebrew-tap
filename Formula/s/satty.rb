class Satty < Formula
  desc "Modern Screenshot Annotation"
  homepage "https://github.com/gabm/Satty"
  url "https://github.com/gabm/Satty/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "03244dd0d181dfccb6b88c199ae1eef9f1197af5cc421c4ead955f80493c4491"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "433fd90d9456bf936cd6719b7388fc2068236888ed877bc9aa0645dfd0bd54c2"
    sha256 cellar: :any,                 arm64_sonoma:  "9dbd499be07e34c243202847b3aeabe816ac1b464f95971daa3249bcfd99466c"
    sha256 cellar: :any,                 ventura:       "e393f783a0d41f937d56c1020ae184dce6f618849b9a27290aada8a72c675d75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf5bc0f5277caa72059628069a73d91f1f205d063a2ac3a62a4b6cfe86229545"
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
