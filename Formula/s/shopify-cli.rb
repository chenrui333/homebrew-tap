class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.87.2.tgz"
  sha256 "e74bcdfcfa3fd691d207d805a286b471e4728a0b581489d843bcf13d0766195d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "81582cfd8a23a7164d903d154de3a404024ef3d808703948e8e91671b92274c7"
    sha256 cellar: :any,                 arm64_sequoia: "8d7fc85da0571e8718a84926fe00a761d343a01fe512c99d19855004cfff4b19"
    sha256 cellar: :any,                 arm64_sonoma:  "8d7fc85da0571e8718a84926fe00a761d343a01fe512c99d19855004cfff4b19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8f5a6eaf6e7622cbf2bca9a8477e3ae9e2135b5cd5fb2b8dc449449eff56989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40abfc310b1bba483ffbb2f3b6b53b4234088f8c6b1f2c98e667e7e2bea7100f"
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
