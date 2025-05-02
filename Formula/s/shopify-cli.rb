class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.79.0.tgz"
  sha256 "cbeef7f6df2197b62f80a1795145e7c2d6385760426ce9a88eb7c7d0f78135b0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "8f9c3d63166808f225acf8dc8c78ef5e4ed19d50a83c5a8716c52dd56e8ca26e"
    sha256 cellar: :any,                 arm64_sonoma:  "d2cf7423cf16892e9735f861f9d8502769a5bd08894d0f6a568fed381de9e6a1"
    sha256 cellar: :any,                 ventura:       "65e15129bbdb4ba3fda0dbacb59aced31ca2b2dd2035b340a269a3bd5c579e6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "946be93f8e12f2320dd75e7593136bfe4ab870058df82cc14518a3ee9ba28054"
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
