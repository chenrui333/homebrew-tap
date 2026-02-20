class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.91.0.tgz"
  sha256 "0ac2632d97e2d63c819bbc85e5837682f1dc156a82de0aee4f62b1e747c31ee1"
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
