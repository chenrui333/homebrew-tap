class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.6.1.tgz"
  sha256 "9dd46a82188aa91ed8aa61e33b6993a61ee35cc57ba9fbaee4f4fa6d0781feb9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "68d82fc7f7e19065a0c419d6e2b2fff3925963dce9f0a1efb53687452dbfec62"
    sha256 cellar: :any,                 arm64_sequoia: "68d82fc7f7e19065a0c419d6e2b2fff3925963dce9f0a1efb53687452dbfec62"
    sha256 cellar: :any,                 arm64_sonoma:  "68d82fc7f7e19065a0c419d6e2b2fff3925963dce9f0a1efb53687452dbfec62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcb30323fdd96626b2ae9cb74094ccf05b03c7e0dfdb435d6aefa89cb46e2afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f898eea90b7c16d31b32882e5deb794d369db85ee105a47492b97647701aaf2e"
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
