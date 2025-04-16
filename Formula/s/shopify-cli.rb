class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.78.1.tgz"
  sha256 "032feb3ee24c620c04bd2d4efa48f8c22749f6b4135940b778cce25100cd4606"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "2eac4b6f7ab782901d4489a5c15a5501fcbd044d9d812ada5c5f878b2d88e5e0"
    sha256 cellar: :any,                 arm64_sonoma:  "2ce2f5ed9361820bc376c5cc697f835d8446a84f771f2b374d4067631522c4b3"
    sha256 cellar: :any,                 ventura:       "294906fa6fadaf72580ba73f17b12cbda6b875fff791cefab50a54069dc59870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdb10cd42b0c3e7f1b83b210a171692226383831f5b43ecd8511f833fd776179"
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
