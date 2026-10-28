class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-5.0.0.tgz"
  sha256 "be3f91be0f8a3cf11fd36f78cebe0b603995b9fa2609263848121cb662ff3899"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5987eb179b8a4aeb6919462d257116ebfbb0c15e8f864cbee873429e62725968"
    sha256 cellar: :any,                 arm64_sequoia: "5987eb179b8a4aeb6919462d257116ebfbb0c15e8f864cbee873429e62725968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73c7b06840331da74e3a7696da70574b4fd71dcb5a320c88e5a2e736f59a32bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dfc2f9bed91d9248cb1b695ad2d30efaced9cb763400aa96c0444d75f2d5124"
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
