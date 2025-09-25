class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.85.0.tgz"
  sha256 "059c4a84a90867795647e1dc942e9fb2c7ec8eb317eee0cadc6a9eaef5291835"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "7a0ecbb16c777c2dbb5ecd2101f6d7ca08fbb706b50406bcfca7eaa1a04f79b6"
    sha256 cellar: :any,                 arm64_sonoma:  "33965deb07a52a70003042d6aca0e92445fd375c72cba13ed7b5beaa6ee39e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad3af1d54c304c0432f05b21f16b3a06b299a997105480df8ab33829ac6427b0"
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
