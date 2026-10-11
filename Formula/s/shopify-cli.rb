class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.9.3.tgz"
  sha256 "afc64aba664b67164080668bad812dc0629586b4175fb2a5a8097155aa8cb187"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "cc3438226347a249a8d7556fdc47d4230e7bb3d9d7d6c92c268eecf07fcfaca2"
    sha256 cellar: :any,                 arm64_sequoia: "cc3438226347a249a8d7556fdc47d4230e7bb3d9d7d6c92c268eecf07fcfaca2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63adc1829e950000640008ecc1e1d4a50239682ed7b4aa4c814dc1db3256f160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c99041e5fd5cc5a6dee1da6e7ea81808e3c3d4eab063bde31ceaf923005557c"
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
