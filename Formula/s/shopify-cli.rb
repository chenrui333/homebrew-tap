class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.83.1.tgz"
  sha256 "f0e80d4c64e52b75530d8bc2d6f42fb02e70d2b8196a8e4113b6ddcdd7a91e1f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "64cf3999f8b1e70e007150696eec55ad1f4f8fd0f67107a8b20154907c6f1e09"
    sha256 cellar: :any,                 arm64_sonoma:  "1629c3287a09d219d6c712d80773f82be227a3c16e8daba249bc62b7b9801e75"
    sha256 cellar: :any,                 ventura:       "ea04f87f0d01069a1ed1a4b6d4c620173731a1173ec3259d5dc1e8e04d2d4aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30c3365beef0dcab455b827751f7a87f16e86688403530eee8dc089536ccf33c"
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
