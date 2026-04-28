class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.94.2.tgz"
  sha256 "22fc26304ebe1f03a4da694b92001769ccd26ec56503db553ac796a543393504"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "9e4f8154f4965585b6a2882119005c7407cb650d60f0b922021b35880dd1f404"
    sha256 cellar: :any,                 arm64_sequoia: "6d1b009b22309b4037cadd37c66be148e286c4ec0d1e6fb107182a6c46833ceb"
    sha256 cellar: :any,                 arm64_sonoma:  "6d1b009b22309b4037cadd37c66be148e286c4ec0d1e6fb107182a6c46833ceb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "939aa63c96c7a81a4bad0eff492683e6b0073f1d2d751f2fa07dbe10eacdb98e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24ce72f9a3a4cb1df61bdd2b128c404db0bfed0fad286dad134cbe5fd0adb192"
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
