class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.90.1.tgz"
  sha256 "a6a7c6d5a47d1be0e9b04c4bce7ab4abb904ad046241ecf89e9dc6421923b0a8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2b691bb2c26adaded3a7d3361a534462b01066c6bac45e3e52b52e6a32371601"
    sha256 cellar: :any,                 arm64_sequoia: "1d4311b2b1e1412623a7214ac693628c5d98f31391ced7be966b037db5a77092"
    sha256 cellar: :any,                 arm64_sonoma:  "1d4311b2b1e1412623a7214ac693628c5d98f31391ced7be966b037db5a77092"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d3ec255c90e9a7a750e634cc1ecfb2ae92dd8d4668e56a5ff7754b79a4e5adb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c402f698ac34880c61897ea66fdaff6b1a8685041c8a42f06c2707a5dfd45fff"
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
