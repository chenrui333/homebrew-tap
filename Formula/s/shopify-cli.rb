class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.9.0.tgz"
  sha256 "f1bec77a24c7fc16d54664fdaf9e0cc3c6caf55cb1b6c267d301b5c8fd44cee8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5a64afeaaedacfa71769f96c0bc82473dd92c59f8640c00f2cd297bdb2d0f91c"
    sha256 cellar: :any,                 arm64_sequoia: "5a64afeaaedacfa71769f96c0bc82473dd92c59f8640c00f2cd297bdb2d0f91c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d109a204006c54f317e5d0372e6751af905c969d48cccef90128155e3109a1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bcbde0f40a4a78b66686e75d769ea28edefbe0b3bbf0fb530565a9277602718"
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
