class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.7.0.tgz"
  sha256 "d859671924ea04a302ccbcfee746bafe984340b5dc1c0dbfd8ce70ad696079b2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "f8455eb7af2f9aa9e9be7fae8942055e9074842a9e4629b8eae0a855b1375023"
    sha256 cellar: :any,                 arm64_sequoia: "f8455eb7af2f9aa9e9be7fae8942055e9074842a9e4629b8eae0a855b1375023"
    sha256 cellar: :any,                 arm64_sonoma:  "f8455eb7af2f9aa9e9be7fae8942055e9074842a9e4629b8eae0a855b1375023"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26054913eaaa08a0f50eea1bc975215a7bc3cd3aaafff65a04d9dc3ba61a42a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "202a3cfcc39d14422cd88994a5d7cefc9bee0940c79c67339b4aca2bb84fb056"
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
