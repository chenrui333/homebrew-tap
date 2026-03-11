class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.92.0.tgz"
  sha256 "3e6b00d5b55301d2622cd9fe7c5927f6626a59898996b17552639e35dad41471"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "65edee2ed1c0a0775375e07baf788d8bad9f722edffeb33caea014047dee192e"
    sha256 cellar: :any,                 arm64_sequoia: "6dcd26c7e37ab605cce74d6ccd8c8b8ca5a065d5507488f86c25ea66dabcc891"
    sha256 cellar: :any,                 arm64_sonoma:  "6dcd26c7e37ab605cce74d6ccd8c8b8ca5a065d5507488f86c25ea66dabcc891"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cbcb717bba7ae0a0e5bd14b25abb13b74b0faffc3f4c1d2ea4e26876b3eb76e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a904c15d9a8a00fe64c7ab36ef3018f5ba457d3322c72afdb47953275b41d9c9"
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
