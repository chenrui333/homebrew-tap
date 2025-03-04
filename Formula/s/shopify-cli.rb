class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.76.1.tgz"
  sha256 "0db652a707ed1fd34afa8678d667495672e328f1c762c9150f823e14df20c8d4"
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
