class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.93.2.tgz"
  sha256 "b6b320b21f5f39b9dfd406d82eab8326bd885f5bd7db7d646529f5aa0066a32c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "33eb89cf706490e2d98ffdad48501acb325b76704ced257a55cf8472221483c4"
    sha256 cellar: :any,                 arm64_sequoia: "0d68d4ee750e903541080dbc4e166a39ef3c0c5c529e193b244be307158bcb6c"
    sha256 cellar: :any,                 arm64_sonoma:  "0d68d4ee750e903541080dbc4e166a39ef3c0c5c529e193b244be307158bcb6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1558bde8da025677b12d35f4dcc5908214231bcbbd6a9dfbd6556269167750c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2661bbcba52820483f5432b3f6b5f9a521771f8b959404d0551a79fa25a795cf"
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
