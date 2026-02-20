class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.91.0.tgz"
  sha256 "0ac2632d97e2d63c819bbc85e5837682f1dc156a82de0aee4f62b1e747c31ee1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8ebe67904895f3084f0c831e76e1052d6ab1bbc739068b615bc5d583321916e3"
    sha256 cellar: :any,                 arm64_sequoia: "b85f102d77eaa2c9a75b3ebbc433b681ed8bcd73f886ca03cb07c8431ffa6837"
    sha256 cellar: :any,                 arm64_sonoma:  "b85f102d77eaa2c9a75b3ebbc433b681ed8bcd73f886ca03cb07c8431ffa6837"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8332a28c9b8fea77a1fcffdd1da3ddc5e8ead88887829e8a2805accbd5c60348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47b55573c9a0250dc8f6114d03138905dfa9055c73840fcabc1f47a224d18a26"
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
