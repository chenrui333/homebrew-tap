class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.85.1.tgz"
  sha256 "df8df615b24e78b6ae90bd973622a3f303ca576dfe1aecdcc9e1e983d5c508ef"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "5a1377871c974fd635f10c15bf6a862f1e38a179e4ee314d448096523ce5e43c"
    sha256 cellar: :any,                 arm64_sonoma:  "7a8997461a87cda3a57ff6f6256b670d4fc63ea035101c0cdf33634e148ee7be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c18d855edc7d9ef5119e1c50d9f73f910a64c3de6f9d51c66b98c13465402280"
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
