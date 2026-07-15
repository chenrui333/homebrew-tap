class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.5.1.tgz"
  sha256 "397f8931046447b69dcc37aa0c180e1749d43105c79bc495a79dc4359d1071bb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6817230d3e2e501a18d472f2f786f8583b29632110611acaf4ae3d861994cd8b"
    sha256 cellar: :any,                 arm64_sequoia: "f77e0498390489f6552d3ddff5c2bb0af4bb1b3768a03686dd103aaab8953b8d"
    sha256 cellar: :any,                 arm64_sonoma:  "f77e0498390489f6552d3ddff5c2bb0af4bb1b3768a03686dd103aaab8953b8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cab4d6a2d8b1c85f9fb54be50eaeee9e63a6824f7cb73401e43cf4657e09f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a33b0efc74ba99923e145a9a49082bcb939075d0b75cbe09c296dd99191925c"
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
