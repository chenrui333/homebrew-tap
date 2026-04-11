class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.93.2.tgz"
  sha256 "b6b320b21f5f39b9dfd406d82eab8326bd885f5bd7db7d646529f5aa0066a32c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "20f53e183c0809d6e77bb37fd89cbb79baacdbfa6174fffaee7fd6ebb856a7fc"
    sha256 cellar: :any,                 arm64_sequoia: "035a10f94292b89db0b21bca13664cd341a3a715c4c369c1a500989b28fd0816"
    sha256 cellar: :any,                 arm64_sonoma:  "035a10f94292b89db0b21bca13664cd341a3a715c4c369c1a500989b28fd0816"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32580e35aae5d407c14d4139a2d9ba2e356ddcafc9ac93bd6670732b2e714b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f77c93110ffd8be6ed010401d06f772f151c9159c24ff72dede06e1f7f6687b"
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
