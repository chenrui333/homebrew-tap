class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.88.1.tgz"
  sha256 "27429847db10501cef4c4855e0a92cc88b2f815973f5347df7ca36299a179680"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5b6f9eb7fc61ec7dde0981460f9ffe48952d9b4c3aae2b6de7b304c2aa128b49"
    sha256 cellar: :any,                 arm64_sequoia: "99eab92a284dcaccbf9dd956704843b593a8a52067e1f0abb699f1ea39e8d804"
    sha256 cellar: :any,                 arm64_sonoma:  "99eab92a284dcaccbf9dd956704843b593a8a52067e1f0abb699f1ea39e8d804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18102765bcdfc10b7e2035ace9f770be173c5b7a66f2a1a0db997abe01e4b9b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ad53ad145759dfa10e351fcc061b29136a248054fea5c47517fcc22d88cafe0"
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
