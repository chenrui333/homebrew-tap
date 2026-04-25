class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.94.0.tgz"
  sha256 "61815cb8e0660803d62a4268e3d481fc6fc489fa90c451e59f9bfa9aa7a84a70"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "4f230a371868876f1f3690774969b6a959d96e3f0d5e91188a406b69b4bf4fa8"
    sha256 cellar: :any,                 arm64_sequoia: "51d14aefe26628ae959f770a3ac389d20d4a987e1b83c1e61972a080fe3d2ad0"
    sha256 cellar: :any,                 arm64_sonoma:  "51d14aefe26628ae959f770a3ac389d20d4a987e1b83c1e61972a080fe3d2ad0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "583e472a930d29fbbcbb8a4a076497e1f2f8c2078230a7f6ded31f7f7c2e8933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3166b36fc33e0167a1444b5e71e7ff31b8071ad9cbe672221b177e92363c8810"
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
