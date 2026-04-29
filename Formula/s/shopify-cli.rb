class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.94.3.tgz"
  sha256 "1bd7fc52c8baf3f1c279478d3954c74359cc868e877046fbb83823ced3595a22"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b57bd5fd1493dc128efc1bc0de7b666fe4740fe95998c40ba0459b712fbe2cb3"
    sha256 cellar: :any,                 arm64_sequoia: "06d093f55d3e7f52ce980e193f56007db1c659f01c40f48bee3337732b24ca6a"
    sha256 cellar: :any,                 arm64_sonoma:  "06d093f55d3e7f52ce980e193f56007db1c659f01c40f48bee3337732b24ca6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09e13adc685a2f4be2127f33810a4404d5c23895ce9b2cd98a48c85b3dcf44eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d0b73607912a1ab45e6942be3f0338376fc5b4e1a36b94ff2783e63d79a5377"
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
