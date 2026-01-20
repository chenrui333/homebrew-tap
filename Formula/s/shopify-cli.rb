class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.89.0.tgz"
  sha256 "0dd44ad9b9edd4d1b60d6ade66393a28b153963bd5c33ed100f5e015f0367758"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e30162b47f48f343fc36994cc35024d15af52d936b9f22b6ab0c2548ed8d3c2e"
    sha256 cellar: :any,                 arm64_sequoia: "a1fef2558547fa6d7a874f663ac623d5f15c9560ac2547a1d44e82c9d8282946"
    sha256 cellar: :any,                 arm64_sonoma:  "a1fef2558547fa6d7a874f663ac623d5f15c9560ac2547a1d44e82c9d8282946"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dacec346d21d154e3f93115db53bc5304c60de2a1c6cf9c27e15191a569d7cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b07cdea604b456b86fec101b3678f13e8b4b7140cccc8ac15be5b2089b257ccf"
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
