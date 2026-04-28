class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.92.1.tgz"
  sha256 "eb6f9a3c8d5d5f23b8335d2e0e8f565d997647d6a4ceac143616e089c004e26d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "cfceea25329b89b0272661ff8d37527f2ae1c3b8a4ed264fd8b96ed4ed56f6a1"
    sha256 cellar: :any,                 arm64_sequoia: "191976d21823b99388f9d2ac3225cc668b53bb9c072785c340c6321d61e78cad"
    sha256 cellar: :any,                 arm64_sonoma:  "191976d21823b99388f9d2ac3225cc668b53bb9c072785c340c6321d61e78cad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b3952b9ef62676f54525c137e393b2b6addfbb70929ada31f7e4c8c9f0c0ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db5ec7d7424cdc46b955799d7a5e4f7ab40404c7501b27040587335111ae587a"
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
