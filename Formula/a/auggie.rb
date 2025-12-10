class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-0.11.1.tgz"
  sha256 "4afbe619db258f106d2742ef6c64330902fceda82ad63a7a25ec88473940b30f"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "c1c130948be8a51b48a90985576780263797c7c30c56038915aae687cd6540da"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/auggie --version")

    assert_match "Total: 14 tools", shell_output("#{bin}/auggie tools list")
    assert_match "You are not currently logged in to Augment", shell_output("#{bin}/auggie model list 2>&1", 1)
  end
end
