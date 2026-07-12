class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.4.0.tgz"
  sha256 "41881c032a48e5d13b301109acb644ed8a8a09a99922773ec1306b5b300dfbbc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "f060acdc4d8f2aac917c99d37f74c1061e8dee5cc27cde4f951128d2c8f58c06"
    sha256 cellar: :any,                 arm64_sequoia: "66da498ade61fecc4bbf04be3e5d394994ce950bc79c2910909eef0de3281c01"
    sha256 cellar: :any,                 arm64_sonoma:  "66da498ade61fecc4bbf04be3e5d394994ce950bc79c2910909eef0de3281c01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3f6b2a8a6b0755ba0c2443e0512ce46516f7ea6b16f9077e93351108657f6c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce2905142615c0b92c9b36a4b302d6678c4b6cf6450ca90723f4c9cee91df6a3"
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
