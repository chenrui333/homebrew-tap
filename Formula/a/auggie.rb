class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-0.10.0.tgz"
  sha256 "fa71a2c12dc1413bf338cc161d1aace70c5db6ae3adff1d1c586c1e5cbdf4813"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "f02d80aaa5e5d9e06d48a211fcc48ab3c0c32c4f6eb2395c11b6f89cf56d59b5"
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
