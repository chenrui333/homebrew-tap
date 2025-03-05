class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.76.2.tgz"
  sha256 "038e40dd330185cca07afa9f58c5d8a3cd29e2138b483b3a5e1e4bc40525f1eb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "0dcf53019d34f56fd8c726c3393777e3a2c6c2da9be6d81501a46c53bf81433f"
    sha256 cellar: :any,                 arm64_sonoma:  "04c16b7ec0cf6888ad5102a82394a50b1830694e1cd5ab6f1f78fa11cbb41b1c"
    sha256 cellar: :any,                 ventura:       "b4ded5e1b8f0219895d5027afedca63abe85a01b9817d5f3bc092642cb44284f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba1e790ce9ac173df70520b59f11a3b43ba1ad953ec5e464e18aff2dfc33ce0c"
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
