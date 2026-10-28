class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-5.0.0.tgz"
  sha256 "be3f91be0f8a3cf11fd36f78cebe0b603995b9fa2609263848121cb662ff3899"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "837c77593a1f4f044a6e415c64abf00b4c2d4b2d98aeb7cb99df8cd743a75a61"
    sha256 cellar: :any,                 arm64_sequoia: "837c77593a1f4f044a6e415c64abf00b4c2d4b2d98aeb7cb99df8cd743a75a61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad6da1adce1bef587fcbf361c74ef8e634b82272448a75b1eba65720e5773c24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d36bcefe33de4d542e3116f3fe187705ba6224605d16b5b5b67d0309ee40d22"
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
