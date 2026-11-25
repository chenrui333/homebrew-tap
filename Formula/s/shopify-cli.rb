class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-5.1.0.tgz"
  sha256 "cc243d8056803e700c1d9038285adcafeea37de624633a8babf0610b60f73858"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "0189a7d1a984f49c1d3a7f801ce8ec9f93d6a1fe5957329b2bc0ebf2d14aab0b"
    sha256 cellar: :any,                 arm64_sequoia: "0189a7d1a984f49c1d3a7f801ce8ec9f93d6a1fe5957329b2bc0ebf2d14aab0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18c6d4a099f8c31597526e04bb7bf35a60eb2e60fd52118710c5d30f77b2f51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4f108a76f63ba05feef4dde08935519df3107dd33f4c2f9a11a476148a479a2"
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
    bin.install_symlink libexec/"bin/shopify"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shopify --version")

    assert_match "app build", shell_output("#{bin}/shopify commands")
  end
end
