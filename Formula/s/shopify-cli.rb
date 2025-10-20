class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.86.1.tgz"
  sha256 "eb4a2e7ae95318acd2c695fb7902048871bcdffcd8bb3fed11156a894fbf664d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "05ffbaa626ffbcb9661af05f8d4c92cd2745dff0ca3f25d27976239a4bdd9027"
    sha256 cellar: :any,                 arm64_sequoia: "95f3220f9dd01a0a46fd9fe293d4586b51e16bc35f08873d9edda09cad00d575"
    sha256 cellar: :any,                 arm64_sonoma:  "95f3220f9dd01a0a46fd9fe293d4586b51e16bc35f08873d9edda09cad00d575"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85f0ffd7b57e502111b9aefe1777cb07fd0dc696fc747fcf95bc3197dd5b1171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5daca85fd20705390c6b51e52ffe906e46653a8ddd8e66f0a30361d129122178"
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
