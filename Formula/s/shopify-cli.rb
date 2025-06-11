class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.81.0.tgz"
  sha256 "4c0f07e2fad771a029fd76c2401adc56faa0b97a765c4fedbb950b5f85446d6c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "17e8cbb4735f2dc731b832b25c78e35e755e660839cd948c2cdd4d525d81e296"
    sha256 cellar: :any,                 arm64_sonoma:  "e74457f0ec6f1b600db90af41d04edfbcb4ed1133d31a2f7b9e1c459d4309e10"
    sha256 cellar: :any,                 ventura:       "6fc2a61c67027f566ff3068e13f0b2bcdea82e187c7f8bf330f296fcbda79594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d9fa6548bd4cace235f61bde0c7ab219c6e8c5845768816311d7f8503616917"
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
