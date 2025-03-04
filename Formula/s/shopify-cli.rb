class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.76.1.tgz"
  sha256 "0db652a707ed1fd34afa8678d667495672e328f1c762c9150f823e14df20c8d4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "cd846f5f713de301187ba344cdbbd1b5d0f71f549eed3d2efaf716e2cafd55c2"
    sha256 cellar: :any,                 arm64_sonoma:  "7f168755de4cfec4047d26f70893c1c6565024f65ec1c6b3cd60f0acdea6589e"
    sha256 cellar: :any,                 ventura:       "a8c8332da85a75bee97a07dd8f1cb74b11ce1e9f07444f59c6fbd41e5a59b1fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bd2ba1b685f9ccb23a3494e2bde459af2f1520b64b13d1ff5f0056a63a0c40f"
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
