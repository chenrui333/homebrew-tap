class Satty < Formula
  desc "Modern Screenshot Annotation"
  homepage "https://github.com/gabm/Satty"
  url "https://github.com/gabm/Satty/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "eee18b5f9eabf164da69c7e6e916c98afb78dd296d83e28bb96d9f9636a5fe36"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f00c1e523c3f9d3dd834ebb1433e69ac9f7ac810a19a330c0743d090c70f589"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "167ced2fb558661dbf3a59629a4f568a59773a9449309848fc635d8485c379d0"
    sha256 cellar: :any,                 arm64_linux:   "4ca9b66a9e7f7b36a8719f34baecb51d90c646ac3178b0d0979b40170b998839"
    sha256 cellar: :any,                 x86_64_linux:  "75a1610fcdcaccf374eb8c51fcf82a793b1429ba9eadf98b824c807aa04823eb"
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

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"satty", "--version"
  end
end
