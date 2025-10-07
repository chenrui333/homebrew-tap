class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.85.5.tgz"
  sha256 "d2e6682474afb8925a10ae23dd008bdfa00db69b36601acfc655810fe1c756c8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "51ca92de81645d71a887427b008aa6617ff1a893445b13d490ca7873d6c91807"
    sha256 cellar: :any,                 arm64_sonoma:  "0f6103ce9d7df8cdc838c9d0bf98927ffa3a4fdd2cc151b2113085e6a0508501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "227aac68e72820022c2f03f06eaf507c89da35f3d291234e257db772a308fa2e"
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
