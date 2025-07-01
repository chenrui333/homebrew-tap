class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.82.0.tgz"
  sha256 "ddcf1d2fcff684286b8c3f1a71321aa7f49a5ac031a151140a15e3d92c02d1f2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "d2b40a8727751639e902b29c607b6ddebae3300ead93ff8879a3e97fa6aa512f"
    sha256 cellar: :any,                 arm64_sonoma:  "01768631177d4ed47cf276493666588b710e4d287a1ccefd8e13ac551ce2a88a"
    sha256 cellar: :any,                 ventura:       "3cad43ed90d339c799edb752f268347fc1956408906c9ade5880f025e16073a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "143c9b8adf7e5ddebc18efe43bf6f2b3c66bbd4ef5ad27c8f9b874d945493ffb"
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
