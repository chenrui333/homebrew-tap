class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.94.3.tgz"
  sha256 "1bd7fc52c8baf3f1c279478d3954c74359cc868e877046fbb83823ced3595a22"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e51cf93de1f500d69151fb5cb2f61bd1b3540b55cdf2a81e939eaffc36f6a205"
    sha256 cellar: :any,                 arm64_sequoia: "d26bf2c9bef7c1b559ee41d62c1c87da4e627923cacbc725878a761d2940f60c"
    sha256 cellar: :any,                 arm64_sonoma:  "d26bf2c9bef7c1b559ee41d62c1c87da4e627923cacbc725878a761d2940f60c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc2a08e97e2c0bb2f2dd5f18109b7f205bdc6b6efaff58024e57cb2beeb9766b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46d4c3b2e3ace43a809fc20c66d3e3c4106bc3b3fa7366b92c2056ea38a4be1c"
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
