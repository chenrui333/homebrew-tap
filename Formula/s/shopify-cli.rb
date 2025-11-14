class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.87.4.tgz"
  sha256 "a6fbc109e0759df9766ffdce268b5776f2f2800dbf8e06b2d3c7427c65bd6d02"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "10f746924c81c6044430aa762583840ba8e46dc1a5ed503b479518235bae26d2"
    sha256 cellar: :any,                 arm64_sequoia: "4b458e129ede9e43111e3bfa6a0d50ccd1f15a55a0388bc7f7e97fa0dcd3f744"
    sha256 cellar: :any,                 arm64_sonoma:  "4b458e129ede9e43111e3bfa6a0d50ccd1f15a55a0388bc7f7e97fa0dcd3f744"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5abbff5bf239444d9bad8a83f1f3c382cb0ed5f6df415448902e49ec37a6924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c77c14043814e4ea48d9d672097855a56ea9b561734ade785033607aff27bd0e"
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
