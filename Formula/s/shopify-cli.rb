class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.79.1.tgz"
  sha256 "f3784d0b1ba79fca372e830d8fab26b050107b400b9af97e218035441db0b942"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "32a5381e7e500a4887f7edf08c26a3451cc5cdb13fcb8b810ea210d172a70d37"
    sha256 cellar: :any,                 arm64_sonoma:  "0485785b20dede27c9909d7a55153fe5e762cf336b4ac92322b9f0b3fc939557"
    sha256 cellar: :any,                 ventura:       "b4a27025b550441a603d9a1a27a513f345177db1f53299675edcc50df2c4bfdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4940139143f90c023d86391c247c33142174d4948b3db46a3c4cf27567764395"
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
