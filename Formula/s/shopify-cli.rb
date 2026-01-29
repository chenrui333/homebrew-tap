class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.90.0.tgz"
  sha256 "31fb8967a65936923a4a91251a9b7a2e37b03b2c00fe697faf228210ec9e87fb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e5571e3e1e430bb38ff12c49af16199a28ea326d0f646e866606b993416262e6"
    sha256 cellar: :any,                 arm64_sequoia: "6ee8f1b0946ba8b22ee602d536dc64d1158c3192efa89cc050758c4a42484ac2"
    sha256 cellar: :any,                 arm64_sonoma:  "6ee8f1b0946ba8b22ee602d536dc64d1158c3192efa89cc050758c4a42484ac2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f70d3de2e3c7b84337e66387c64bd57cd610c570c6bd6ebf7aa80cfeb0996317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a17ef93a87d567c5b82e6e7651e8afe972351cb012e94a0e9b6690cc42695498"
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
