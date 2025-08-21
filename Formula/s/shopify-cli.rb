class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.84.0.tgz"
  sha256 "7a7076e5beaf27e0f20c205e0a7d10d7961b84d536aec3e818c982e8f6532ec2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "d598c1c0aec66dcd5a96709a51af9781c882b0b26b97b0df2123af8c5d5a77bc"
    sha256 cellar: :any,                 arm64_sonoma:  "13cec749e3cab618b08c34c6dbfd40801b3b7ff781f1693888cfefef20a174d5"
    sha256 cellar: :any,                 ventura:       "627acf8f84673cb8b94a99fdee4336a4864096d3f32f603d4a96dacca1158867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae4dd8e4e79b7c0ba3fa4828effe72cf9a451837effb1d1b1a0e002a38d24c0b"
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
