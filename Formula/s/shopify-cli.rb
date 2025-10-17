class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.86.0.tgz"
  sha256 "6769c7cdb18f7c9012bb42ad4f41e4b96cbb0701a9646afc32af02195dca498f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "d9c6f676b2292281ff7500cb997d36eebd1444db7fd55be9a1dc6ffe9efcdb50"
    sha256 cellar: :any,                 arm64_sequoia: "4faf1fd4a6e03ebf220497376307ee9f51527c41d68dc288be0430b20dc50497"
    sha256 cellar: :any,                 arm64_sonoma:  "4faf1fd4a6e03ebf220497376307ee9f51527c41d68dc288be0430b20dc50497"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be3b023dfda0271f6fb3e490ced9c2cb2e1d3da91017c2c4c0f215d3229bd0b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35a0f6035c6f01bd481e33fe0c1f20422938c180c69d291a4aef6f9d952fc58e"
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
