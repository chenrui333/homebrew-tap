class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.75.4.tgz"
  sha256 "f6f9d059ee9164fac71ee6c7135b6d6657531fb5c2acce68047d20ac0d6e27f8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "838a4241ffa640573478be6335f9de8050cff46548903cdd4a2b8d85001fd4be"
    sha256 cellar: :any,                 arm64_sonoma:  "a8a40285e1d102512ca22767916253a312141939cd7a67276531743780fdef8d"
    sha256 cellar: :any,                 ventura:       "276b246339c54282f39a546fe7e6f991a38364a55383a4135ee0fbdc8895da74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00e58bc8a642ed93feee2fc6937e4ce8d33c1d7415f646e8f283abe4fb9f6805"
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
