class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.80.6.tgz"
  sha256 "cf3cd595fafd4ee4a37fab32d85ce687b0142a6919ebedd52514f77856d8dbc8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "a76ccaa2709fa716bc78742dac688bd81b9e3fb98114955421b9ddf56da80ad7"
    sha256 cellar: :any,                 arm64_sonoma:  "b6864741aa9119e3fef6c3775dd6a40b55a82f82a3763d119f769c7ccf20555f"
    sha256 cellar: :any,                 ventura:       "e4fa06b3166675385815ef2d54af48ecf7481422dd3e9131088b5379dff2adfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bde3e94fe7aa31d9a39e8f86d5ed0aaf7a00b5857d37222529db518c4723575c"
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
