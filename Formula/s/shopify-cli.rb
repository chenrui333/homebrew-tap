class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.83.0.tgz"
  sha256 "8664a39af524ffe3111dd5e187aad41674cb4464f6357358e4a8a1a5ccc78b0c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "d3c461b98e09a44bb1b2b0faa2a513f54a7221fc4312ab6c5332ec5d49d2c38e"
    sha256 cellar: :any,                 arm64_sonoma:  "8ce4501a290712a8f277fc017034add26a768f64cad1eeb4ccbbd14560c76b19"
    sha256 cellar: :any,                 ventura:       "46bea2c9037b15db0d9c14f04d772861929b71e2634f2afb8eac443c7b038ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e0b4d32d623fb0206baed649e0a39dcf481cebb0fade96a6e84f6c3e38d989e"
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
