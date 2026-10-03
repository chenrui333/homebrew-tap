class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.8.4.tgz"
  sha256 "f1cd993e65d5f9ccae0a10ea052b25e3ed98bb9bfb86857abcbe560345826a4d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "78372fb1d6355d6c46d0f2860d32b950247d4f00a28b4d6ab8cab5aca23456bb"
    sha256 cellar: :any,                 arm64_sequoia: "78372fb1d6355d6c46d0f2860d32b950247d4f00a28b4d6ab8cab5aca23456bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1707ff3a633da0e1207b891b90a9f4b7d60caeb127bd80822c41fc41290b0215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21038b1daf85fa20894ad7dc78abcdb7c96f04adef0e0b3e6d7959fb57efa103"
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
