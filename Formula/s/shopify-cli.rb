class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.85.2.tgz"
  sha256 "6b761131ea80e88fcada57df4cedca89bbcf5238aec419c030efe67363db5340"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "dcc9a38f6e96a2a212ac27abb1ab2c0fe52b02dcabad4d3e453397c1f22bd4c1"
    sha256 cellar: :any,                 arm64_sonoma:  "edf3b29d289fc9731261529fd745e402fbd507620bc149854a7aff79b4af1699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c12205160022d1191e648e8a1154aee6e463fe7551e5db2ce6b26cc9b936c368"
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
