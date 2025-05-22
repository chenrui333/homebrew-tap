class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.80.7.tgz"
  sha256 "50055bb351e709f18b21a701336888ab336c47556af963625564e1e49bdb124b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "732418ee2e8edb61175a29cc5b01ce056b7ecb564f3c4d76c846c81f52298a3a"
    sha256 cellar: :any,                 arm64_sonoma:  "775d138a73ed3941cc60c46d9f3572719ca150e6e386550900fb696599881d1b"
    sha256 cellar: :any,                 ventura:       "effe89b78b8905af0be69cfa803957e698b6b6e52760738b12e6d11a92f3c8f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa8d1d0bc9adaa076310370574ab3087cdd8262bf88cdbacb6b0ce63a4351f94"
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
