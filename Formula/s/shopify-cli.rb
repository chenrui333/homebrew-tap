class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.1.0.tgz"
  sha256 "d9163ff07bdfbf7126e227d8cc789bb9a685c58327ae6c3c7834bd22f8b080b2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2fda4a2e8ee61bd82acaf6effdc8d5e1e32121241a3860ba89335e43d97fb4f1"
    sha256 cellar: :any,                 arm64_sequoia: "c08700eb14d6aff9893ec2e20d3c914f60a274271a620d99bcf74e881be9468f"
    sha256 cellar: :any,                 arm64_sonoma:  "c08700eb14d6aff9893ec2e20d3c914f60a274271a620d99bcf74e881be9468f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a38be66de1109052fd3b9207af7212995555b3fabd52dcd6e4dcaf9a581b30f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03d73050fd0b521ce29a9d95041d73f8e5b5b7ba3439c2fc4d0193e80fc21f8d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/shopify"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shopify --version")

    assert_match "app build", shell_output("#{bin}/shopify commands")
  end
end
