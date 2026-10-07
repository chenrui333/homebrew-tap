class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.8.5.tgz"
  sha256 "268b6ca054ee484ba9bcfe5ebfd6cd2e34770e74cc538a831f2050ba01090b18"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "016cacb462c22d4bd4392c5cfe7169637bff89abe5d8cd0e1fdec51c388315cd"
    sha256 cellar: :any,                 arm64_sequoia: "016cacb462c22d4bd4392c5cfe7169637bff89abe5d8cd0e1fdec51c388315cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "533f2379608eb7adc5d80648adbfd4cc84a14a178c169449925e0507fbe1e0c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be7f58f86fe6e1b02456aa00a2dc936c9044c643d4c1a43ad5c39c3263aba9ad"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    rm_r libexec/"lib/node_modules/@shopify/cli/node_modules/clipboardy/fallbacks/linux/xsel" if OS.linux?
    # Skip the prerun npm latest-version check: upgrades go through Homebrew, and offline
    # (sandboxed) runs crash with an unhandled `onCancel` rejection from the bundled `got`.
    inreplace libexec/"lib/node_modules/@shopify/cli/dist/hooks/prerun.js",
              %r{\w+\(\w+\)\|\|\w+\("@shopify/cli",\w+,\{cacheExpiryInHours:24\}\)}, "void 0"
    bin.install_symlink libexec/"bin/shopify"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shopify --version")

    assert_match "app build", shell_output("#{bin}/shopify commands")
  end
end
