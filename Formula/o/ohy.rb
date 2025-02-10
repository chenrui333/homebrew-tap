class Ohy < Formula
  desc "Lightweight, Privacy-First CLI for Packaging Web into Desktop Apps"
  homepage "https://github.com/ohyfun/ohy"
  url "https://github.com/ohyfun/ohy/archive/b5676863b12308bb68332b7847764f69a9eb60bb.tar.gz"
  version "0.0.0"
  sha256 "2a4d81d68f429cb30b070ed03f1cf02c38b2da4317d5fe91e29be37decc51734"
  license "MIT"

  livecheck do
    skip "no tagged releases"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "libsoup"
    depends_on "webkitgtk"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ohy", "--help"
  end
end
