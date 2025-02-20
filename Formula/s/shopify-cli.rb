class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.75.4.tgz"
  sha256 "f6f9d059ee9164fac71ee6c7135b6d6657531fb5c2acce68047d20ac0d6e27f8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "7815035d3b38621299e29973ee2f98b4fd246bfb57b5bdade8c57b9cb8bb2155"
    sha256 cellar: :any,                 arm64_sonoma:  "9de9109be25143d3a768499ba85df90170e06e7d473bb8150af91fc573201485"
    sha256 cellar: :any,                 ventura:       "56d86e97e615767372bc1bb2b4f1e2bdc143614d54419c62607bcd92c213a769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeb2062d3a7d8a6bd56e9d801df3a7b55bf7561ae4f9ebb0be169f849050ac45"
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
