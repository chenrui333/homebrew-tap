class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.6.1.tgz"
  sha256 "9dd46a82188aa91ed8aa61e33b6993a61ee35cc57ba9fbaee4f4fa6d0781feb9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b79a3a7784b7c63cae504b805d190e33104138062b2030a366739352954e63d8"
    sha256 cellar: :any,                 arm64_sequoia: "b79a3a7784b7c63cae504b805d190e33104138062b2030a366739352954e63d8"
    sha256 cellar: :any,                 arm64_sonoma:  "b79a3a7784b7c63cae504b805d190e33104138062b2030a366739352954e63d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "551ab2b522ddc86bd5e7787917a893b5a7e86bfc2727e1983f298d324b3a8eb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c8608b681744237041641beebf8eb2fbe97933397f579e9d4919ba99d50ef04"
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
