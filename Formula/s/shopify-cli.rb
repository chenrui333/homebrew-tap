class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.84.0.tgz"
  sha256 "7a7076e5beaf27e0f20c205e0a7d10d7961b84d536aec3e818c982e8f6532ec2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "3974004dfe79012a33f7794fdbfbd4860caff9ea3b0b9611c8cebbb8a0b4c449"
    sha256 cellar: :any,                 arm64_sonoma:  "2f6eeaece71f31aaab88dfa4018d4478fe5f91c6f10da307dc8838403cd9ad1f"
    sha256 cellar: :any,                 ventura:       "6d218da48dcfe06083384649dee29b840ff1987d5d5db0e006ccc64d097cd493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e09508e4bfc84ed367c026391a587000c4365da5cadfad9c3496d457900eeddc"
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
