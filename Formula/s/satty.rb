class Satty < Formula
  desc "Modern Screenshot Annotation"
  homepage "https://github.com/gabm/Satty"
  url "https://github.com/gabm/Satty/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "86e85e8abdcfee925f0b95d424bd9eed9ad78aeb537707132e77ccb63133ac97"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2dc1f536f560fd7eb2c4f8615786be5b4f0df4d530af8189240dc19583b6ffd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c56fab3be0f8a2c51e892d71c93750c7e930af34fee10d7849b14a0df10da7f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0da269bab59fdd8732130444d1a14ac8a532a0cdf4586adc829460fb3c6fa888"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eeda71c68578ab4f1c3333b021f7bad79c21f8ce81b02a80aeb2b8d33903f3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b589e04915e3981d992c8416aabc15566e64cabe70f5a75d1c0905d6f582498"
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
