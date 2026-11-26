class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-5.1.0.tgz"
  sha256 "cc243d8056803e700c1d9038285adcafeea37de624633a8babf0610b60f73858"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "69d596761b37f84f0a8d8cba9c3bbb92f6296e2ec0efff0c3910fb1896a7b566"
    sha256 cellar: :any,                 arm64_tahoe:   "09e3dc9395f8600f3cf00601a38dbfc62898d6725f3a86babcc90be211f72fe8"
    sha256 cellar: :any,                 arm64_sequoia: "09e3dc9395f8600f3cf00601a38dbfc62898d6725f3a86babcc90be211f72fe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8966b552c7f6ed5922841fb5df5046125e85ceefd12dbe089ba8ff48a4f07f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a410beaf5da99947848590174fc673814d71a508ee5fbfd4394ae7a3dcdbe71a"
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
