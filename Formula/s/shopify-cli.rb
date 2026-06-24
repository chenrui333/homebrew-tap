class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.3.0.tgz"
  sha256 "a4ce6a3ee399cb5209d9d6b8bd522e4e47ba5b481c37e505a0c9f4729c914a39"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "4a2ca15c40caecf8e88dc792559a23096614266b045056021cf884561bc90787"
    sha256 cellar: :any,                 arm64_sequoia: "469b74b4b7adfe942cdf697e2a7885b5f82503e3d7faa25058d35c0e8ea549a1"
    sha256 cellar: :any,                 arm64_sonoma:  "469b74b4b7adfe942cdf697e2a7885b5f82503e3d7faa25058d35c0e8ea549a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1010ca816c362a26de0cc293ab7ca48c637727a47f73c5465689f2dcc6b309f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88d95cdfa94be6fdd69e33074a4ac2f89e87b4ee157bb6c90abd35a14d952f3a"
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
