class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.91.1.tgz"
  sha256 "c5a01583c30c6e74761f870459cb0a50f8bd2e0e5d3863f4ca8b9cf8de280cff"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "55d3cce74da384839cd03c3c80f116a58a856f61cdce2bae4e1f30c40c1b1591"
    sha256 cellar: :any,                 arm64_sequoia: "da3bee259ab3fc63545d03b0c18fc5d0093f794900af1028a31d9f6e06491a56"
    sha256 cellar: :any,                 arm64_sonoma:  "da3bee259ab3fc63545d03b0c18fc5d0093f794900af1028a31d9f6e06491a56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61af3383c98a8622505e907a34780fcaca56660db59ed1d21abdf9ee0ac5b1ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8846e417d0e0972bb5a8db6c7aebdec4399911796fb89f5f19149d88c14e8b6"
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
