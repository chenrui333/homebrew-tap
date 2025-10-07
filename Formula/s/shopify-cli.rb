class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.85.5.tgz"
  sha256 "d2e6682474afb8925a10ae23dd008bdfa00db69b36601acfc655810fe1c756c8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "45f333c7dcad0c1644b236120b2430f4cb0962d76f8e8e887648df2cc125430a"
    sha256 cellar: :any,                 arm64_sequoia: "a6b1d345fd5e597963036ad6095a87bff6f727819123c49016a875078e98c27d"
    sha256 cellar: :any,                 arm64_sonoma:  "b7e7f8d56c80e4ef2569dc1e45957f271508a7eb369381cf38b553d94bd05423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7707ee0c4d2d48df717550ae2c43586c7335f245054f04de8e1c3633b70ada2a"
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
