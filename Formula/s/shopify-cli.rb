class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.81.0.tgz"
  sha256 "4c0f07e2fad771a029fd76c2401adc56faa0b97a765c4fedbb950b5f85446d6c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "a956f1b1107dbded7fcbe9b2dd0a30d6408f79295a25845a805afcd4acd04356"
    sha256 cellar: :any,                 arm64_sonoma:  "bd37e8a81323daa4028d28d3a8f2e352cc68993493d35d5348b76a16c07a9f3f"
    sha256 cellar: :any,                 ventura:       "c51dbeec50604455d430db5c26cbc51b80cbeaed228ad4d0388c74cf5e40db58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afebc0bd5fdb8ca3f2235cf5c31d599f259d73ae8bc814eef5337de958a05b5e"
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
