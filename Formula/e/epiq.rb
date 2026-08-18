class Epiq < Formula
  desc "Distributed terminal-native issue tracker backed by Git"
  homepage "https://github.com/ljtn/epiq"
  url "https://registry.npmjs.org/epiq/-/epiq-1.4.2.tgz"
  sha256 "7f7686535844741ddb5f0322f125990a3016afe3ddf588f0c361b1f000d1e0ec"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "51c9cc0fb1d85edbe055cfdf1b162a3bb1f4f757c67bdf503880018303801845"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/epiq --version")

    assert_match "Unknown command: not-a-real-command", shell_output("#{bin}/epiq not-a-real-command 2>&1", 1)
  end
end
