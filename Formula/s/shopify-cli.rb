class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.83.3.tgz"
  sha256 "e1a7ebd801cd8a6ba032912b8199d4cbca328a8a9884b6d22dbb12da8e13a528"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "7c6528b3447ce24bcd6fc0d17b832a29570575e9f48b294b3053bf1a4dd5794a"
    sha256 cellar: :any,                 arm64_sonoma:  "cb12ffe553deb9a6b25c48fceea2fae0a4e68b0cbb19548296b11064cfa00a02"
    sha256 cellar: :any,                 ventura:       "35848c8dcf1ace5963940f6af19814d60a3469c36bfc9b36d80800d5db1f7fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00b66baf598ea0d2713da0b080f21a09958a3c7612bcbd626bd4a46cfdc9ac84"
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
