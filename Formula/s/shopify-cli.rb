class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.83.0.tgz"
  sha256 "8664a39af524ffe3111dd5e187aad41674cb4464f6357358e4a8a1a5ccc78b0c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "41028537964fbf9976aa0c15e340f8f3001b522e065e916b983a4eb86ab71252"
    sha256 cellar: :any,                 arm64_sonoma:  "a36412edf08e1fadedeb13a32b7bff6541068f4e5fb5cfd329aa99c09b70c61e"
    sha256 cellar: :any,                 ventura:       "68a0070ab92b14f53bbfe2ef309fa70a250a3a3952e341e670a38db76cbd6e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67b5781e1a05739190c88102886f942fe256f69af9774afe8103fbc934fdb8ed"
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
