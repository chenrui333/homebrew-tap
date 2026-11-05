class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-5.0.1.tgz"
  sha256 "3ba23fc570a183a46ea3d5ee7115f2bfe6d621146ee63c9f444f7e6e620fd77c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "39512f403df6d66ebbdeea94c52630043b9828aa084e5756645a46402e11ca37"
    sha256 cellar: :any,                 arm64_sequoia: "39512f403df6d66ebbdeea94c52630043b9828aa084e5756645a46402e11ca37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebc47f262ff9675a58055ea0ad4dd88050439cd0a20f719e990e84fcd71dfc26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9418d1bb598fda7afdfa585966ead375233a32722e0d569f9c3459cbad622a04"
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
