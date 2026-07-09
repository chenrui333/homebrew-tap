class Epiq < Formula
  desc "Distributed terminal-native issue tracker backed by Git"
  homepage "https://github.com/ljtn/epiq"
  url "https://registry.npmjs.org/epiq/-/epiq-1.2.2.tgz"
  sha256 "7ab51298974a5d0b038a4fd38b5b487d91417346b7beeb6b0f0eda9f8786eb5f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "73b15c5f0f3a33a4b2e17876038c78adaa25e05bca959b02a596c7eb9b9ddae3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/epiq --version")
    assert_match "CLI based issue tracker", shell_output("#{bin}/epiq --help")
  end
end
