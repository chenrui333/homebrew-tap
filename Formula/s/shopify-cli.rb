class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.87.0.tgz"
  sha256 "3ff0271155293349f15b30596ee9b3b68745cbc8501c4a438124ced3117b4273"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "0f5b8a3942cd02c4acc32df6f4eee529788de1b496ae6af259826af885567ca2"
    sha256 cellar: :any,                 arm64_sequoia: "4e4f5ff989b903dce98e25deafeb684189f1bd459ca17d0cd6a1464987f2679b"
    sha256 cellar: :any,                 arm64_sonoma:  "4e4f5ff989b903dce98e25deafeb684189f1bd459ca17d0cd6a1464987f2679b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c9c3f0f1f032948b2ea494829e785835e7ab629b14fecfe9a40e4fd2f0983c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f8853a31f44521688f80f910316e5dc633cb350171e003ae0dc5634125733f6"
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
