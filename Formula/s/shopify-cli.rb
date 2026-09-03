class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.7.1.tgz"
  sha256 "bdf8ca63247d61428137006628178bffa60f5dd9db55c13125c252bbf3f7007c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "81e6d626c8f245963aabd92a27b5e8b755a22b5f99adf9c9ca1622d17d4b493d"
    sha256 cellar: :any,                 arm64_sequoia: "81e6d626c8f245963aabd92a27b5e8b755a22b5f99adf9c9ca1622d17d4b493d"
    sha256 cellar: :any,                 arm64_sonoma:  "81e6d626c8f245963aabd92a27b5e8b755a22b5f99adf9c9ca1622d17d4b493d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56b2788addd4a7e3e4c1bb9d23f01bb4945ec6369cadd89b920b65eeb99a8e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f80cb86645defb6c24a520f4e5ec2e067e6f30da8957724e7d65b68ac3ce3121"
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
