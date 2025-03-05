class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.76.2.tgz"
  sha256 "038e40dd330185cca07afa9f58c5d8a3cd29e2138b483b3a5e1e4bc40525f1eb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "34368a9824414ba0afffc551d83108aff8d23b9504a0142d3bdda50ac0598157"
    sha256 cellar: :any,                 arm64_sonoma:  "904af49af7a30e83bd3ca5168de1fcfdd514e83932f9462b0ab6d64dd57eeeb8"
    sha256 cellar: :any,                 ventura:       "eee2d0143c37ac6387063bc63ba9451d95864aba82cc892851ea8509ca603bf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33bfdc57eb7ccc99cc3b7d5ad95d41b2ce8777ed2394a87c516303c247753430"
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
