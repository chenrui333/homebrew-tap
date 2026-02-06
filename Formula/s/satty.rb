class Satty < Formula
  desc "Modern Screenshot Annotation"
  homepage "https://github.com/gabm/Satty"
  url "https://github.com/gabm/Satty/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "86e85e8abdcfee925f0b95d424bd9eed9ad78aeb537707132e77ccb63133ac97"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "babeab398dce9355f09922e5618c3434728e9077a5da09a6fc2279076531c217"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15b8319decc13248bac546b8866da5d6229430b75230e86ef7f9d1761e3e432a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09f34d28fa3f65c3fc7cb5b19f5c3f4c593707b6b3b984256fb803af075c46aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb9e67f925a508df18036c25ad79d8e984d25102eb19902f15c2d6b14fc2acdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77691fee772fe19f7e31f06b4486b4bcd7c2c7ec04717d4d8adc131c5b2f33a0"
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
