class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.8.2.tgz"
  sha256 "0b1c01d1ebf1f1265826a4ffa78ea94bc4c2eb8a36beb9b2f5fb305ef30231ff"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "073002b7c79b7b20b5f4966fc8384c235c3f394a939435099d61740396550f6e"
    sha256 cellar: :any,                 arm64_sequoia: "073002b7c79b7b20b5f4966fc8384c235c3f394a939435099d61740396550f6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d70895659fa396f9d352a1f5a3093a7fa2d6c90f306419c9a66d585b6dc7940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dde891fef85a94b90d2f2b79180dc84c167168745f1514dcb9823a44e3159496"
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
