class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.81.2.tgz"
  sha256 "d35b6443ff77771ff5c351bb6901ed8ee18c5d8e3d644dd7dd19c6894c702f93"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "b5a76763326f70cc06d559de1d9acdee0c932302a98940981957b25ece9c5bb9"
    sha256 cellar: :any,                 arm64_sonoma:  "32e6fa955673c8f341c7b3ed909562e166b520c592d5422d72260cabf01753f5"
    sha256 cellar: :any,                 ventura:       "44b96b3a70f7c6976522dd8a0c345a6a15bd23407cc97a20ac46d30a7134d51e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af5926f213221eb244bb92c62d0248350100e7cf6ceeab8054ae4879dcb84590"
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
