class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.8.4.tgz"
  sha256 "f1cd993e65d5f9ccae0a10ea052b25e3ed98bb9bfb86857abcbe560345826a4d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2dcc45b13018df1ba081b10b20332a558f1cf634893d6c63ee5e5db7412b3bd6"
    sha256 cellar: :any,                 arm64_sequoia: "2dcc45b13018df1ba081b10b20332a558f1cf634893d6c63ee5e5db7412b3bd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83604311e18a6bf8bded95ecb85ca49f7efd0cf3002ef0b81600632ebd1b9c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6990cb1c426b32d7b5eb79a889965235e1c6f3f2d24c7907f31493f79b1f95ce"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    rm_r libexec/"lib/node_modules/@shopify/cli/node_modules/clipboardy/fallbacks/linux/xsel" if OS.linux?
    bin.install_symlink libexec/"bin/shopify"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shopify --version")

    assert_match "app build", shell_output("#{bin}/shopify commands")
  end
end
