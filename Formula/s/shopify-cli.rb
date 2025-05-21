class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.80.3.tgz"
  sha256 "234bc6b966e69a2e4753cd471dbfaaf1cfea556f9cc9e98303a9a4f2be64e218"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "166fc11223d09e8093c3eb3e41e3feeb4e075fd91b673da2d3addad415f38d4e"
    sha256 cellar: :any,                 arm64_sonoma:  "dc32f2c5c97b96160489d06d3435d214348b658287ea2336c11a85f526365711"
    sha256 cellar: :any,                 ventura:       "f116f41284990cebebe52bf95f6c4f4d3a5dd23e1028c48e8507ab85caff547d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b5db3a7396bcec61893dc92f4ed571455f925573ab64bb006f25e398d0b753c"
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
