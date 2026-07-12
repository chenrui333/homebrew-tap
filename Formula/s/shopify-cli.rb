class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.4.0.tgz"
  sha256 "41881c032a48e5d13b301109acb644ed8a8a09a99922773ec1306b5b300dfbbc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "065b7ea0b0df78a9fc7080cd2241baed93ec404848e02c899db0b3d2719d0fb7"
    sha256 cellar: :any,                 arm64_sequoia: "c2519b5033bc22564825953f00e2c79b13923672b2aeec91dd82b0a14969fa25"
    sha256 cellar: :any,                 arm64_sonoma:  "c2519b5033bc22564825953f00e2c79b13923672b2aeec91dd82b0a14969fa25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2105178c0cb1265a28dbf9ffb946672b38e92e8cff58d14f45fc6a4e9a0a76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0498070117df6a859097439d7640663774646032a6f1f6e1a67957764adc3377"
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
