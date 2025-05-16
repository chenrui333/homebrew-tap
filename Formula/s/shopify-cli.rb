class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.80.0.tgz"
  sha256 "a826d0183d5c172e3e8a980ca2a606c04b1da02dc5f0372d16bf2199b33bd9c5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "fcf1f3e1b1aa402c0af6283a92f9ea3d200d6ba26fb7bd0c521656867275be20"
    sha256 cellar: :any,                 arm64_sonoma:  "8f7a72a3553380c2b3b6eab60875b92d0037eb4b746ef79b9771750bff90d190"
    sha256 cellar: :any,                 ventura:       "54aacb3a33b14629d00bbeed7c03804d289ec82d95ce5881a28af5c41581544d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ea7c7ee3141998a801ee768a2bc77302c76be9b0a0527ec85472ce1ae196313"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/shopify"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shopify --version")

    assert_match "app build", shell_output("#{bin}/shopify commands")
  end
end
