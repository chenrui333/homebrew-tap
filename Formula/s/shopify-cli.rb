class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.79.0.tgz"
  sha256 "cbeef7f6df2197b62f80a1795145e7c2d6385760426ce9a88eb7c7d0f78135b0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "7d4e8fcdf8619d88e7184c9e8b131a894f819e3a667266724dae122a5cdfbdf6"
    sha256 cellar: :any,                 arm64_sonoma:  "77c96f0aac1a211fd18ebe037a2ccc07954de0a1327f152439536e6463868f22"
    sha256 cellar: :any,                 ventura:       "64e3cf4c357a58a19d775cb75cc63d0f585ff8c6a08dd0d378810f7f639d38d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae0cf5768736f43e356320f2df53479e0934807b18688c69a1a50777f73cd8fe"
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
