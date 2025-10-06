class Editly < Formula
  desc "Slick, declarative command line video editing & API"
  homepage "https://github.com/mifi/editly"
  url "https://registry.npmjs.org/editly/-/editly-0.14.2.tgz"
  sha256 "87487bafae25c2fac59a21de935354e338d069b66b39e40a5e355ed2432820c4"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "python@3.13" => :build

  depends_on "cairo"
  depends_on "pango"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "giflib"

  depends_on "pixman"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
