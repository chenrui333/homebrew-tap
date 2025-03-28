class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.77.1.tgz"
  sha256 "8be067b37046be61fb2d84fcab8db36508f54ad3a4eb1c9da07e9aef7fe43488"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "4845eb8a35e48034bcfb6d05cb3c028a71ba95c4b8a2a6ad2655d674b8d811dd"
    sha256 cellar: :any,                 arm64_sonoma:  "6a89b81a7c9837344b32cf528ac022fc9fd259f11cf23e3e1f102cf48bbd477e"
    sha256 cellar: :any,                 ventura:       "d7b5239692939f040052930a7afd574464880460d3afdd337648070517936620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6d576054429fc66d19a1f35b9624fda7e017caaac5544b812ba22517cf20f2b"
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
