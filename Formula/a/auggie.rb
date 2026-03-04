class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-0.18.0.tgz"
  sha256 "296d205abbbeb9da8bd44061e1c020c715d09dbde436160e72506d95ea8296ce"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "c50ad6478946ed3a518f44137486c43e4a3cbf0083281927ad200223f551572c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/auggie --version")

    assert_match "Total:", shell_output("#{bin}/auggie tools list")
    assert_match "You are not currently logged in to Augment", shell_output("#{bin}/auggie model list 2>&1")
  end
end
