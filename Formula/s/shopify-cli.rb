class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.78.0.tgz"
  sha256 "d1367a3c9914cc15a9856ec467aa6c2550448e0fe1f446a54e7511b652d3837a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "13cb94770e987bc5cd460bb58fcb90ab37238d66fbcabfe6b6fd986914008e44"
    sha256 cellar: :any,                 arm64_sonoma:  "4330e8cfedb0ea1d6f3b1363b32a0f7c3c584a5a9cb3b0bfd912bef7ccaaa342"
    sha256 cellar: :any,                 ventura:       "c2bf18e310b8e37988102660be068776d1a5d1af3bb4b12e5fa9a90be55498f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65562f014d3d8a7ded8e1cef3f03be454d62be583b3a52bb125e03d9cbbb1794"
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
