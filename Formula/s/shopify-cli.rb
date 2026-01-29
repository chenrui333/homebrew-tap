class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.90.0.tgz"
  sha256 "31fb8967a65936923a4a91251a9b7a2e37b03b2c00fe697faf228210ec9e87fb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "587d79a17c6ac6f022f0772bce1dd9c6e20f9fa0b7212f69eafebd988bf7c815"
    sha256 cellar: :any,                 arm64_sequoia: "efb63673de10a1337a1d22b8681e87e22e6bd35975ccb048c5efca042f980e04"
    sha256 cellar: :any,                 arm64_sonoma:  "efb63673de10a1337a1d22b8681e87e22e6bd35975ccb048c5efca042f980e04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09bd9c6f4d037f92b689a9201ba46115ab72553abd08e27ad745083c92c0e921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00bf8a780a6504973a74c6ab2e186cc4526efdfcc591c0f2fd2cf75538e82fa6"
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
