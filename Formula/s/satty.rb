class Satty < Formula
  desc "Modern Screenshot Annotation"
  homepage "https://github.com/gabm/Satty"
  url "https://github.com/gabm/Satty/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "890384695583e649074f453f2e694fd2cae6960c189363f849e2ecd2a27f8b79"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "691e1cc5b5288ae2cba2a14a65fb25e9da3f2f649c7952eb41536b08fbc21528"
    sha256               arm64_sequoia: "bc7492b43e962fad3f7fd4d9fd4445aa8eb9ed69e33ba6830393ba558668dab7"
    sha256               arm64_sonoma:  "c488c8f51971052566e2c7051b5cc3186ba09b3c506683f2f270b1a27e4ef1a8"
    sha256 cellar: :any, arm64_linux:   "a6e7cb9a74bb74db8fcf28bf43a35c158751261bc5eac23db7927cdd84998246"
    sha256 cellar: :any, x86_64_linux:  "6a5f9ff5bf83ab2ba77c66c2b3d7e8f237f60896524b47ccac0b9a51caef9c8c"
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
