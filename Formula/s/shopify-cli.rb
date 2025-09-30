class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.85.3.tgz"
  sha256 "2a7168de1c3bd5e7e3e7426b1f07de995eb8d0b8efcc46b3e5086918238a5fcc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "dcd5582ebee5231b2113e025d2f515373f9bc59782ceb6d1f6d5fb6257f65d9d"
    sha256 cellar: :any,                 arm64_sonoma:  "1e4b7380db09d64b2aaa1ed87df9dde3588855ce5d90054be70356a344f7deef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1cce905c6242b1d885669124d25f6316f4d91b8b425d30034644e0a7ce418e6"
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
