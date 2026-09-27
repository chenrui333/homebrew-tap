class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.8.2.tgz"
  sha256 "0b1c01d1ebf1f1265826a4ffa78ea94bc4c2eb8a36beb9b2f5fb305ef30231ff"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8a00a98a554dcba461744018b2207eec33f911852fe30a426a45149d6569bbda"
    sha256 cellar: :any,                 arm64_sequoia: "8a00a98a554dcba461744018b2207eec33f911852fe30a426a45149d6569bbda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a615208b725249079672b5d5bff432b3aae675b2e73114c19c8df513745a76b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "809b6858374e6fb76da8ecc164cbd3e6d11d17251ab187e592da3dcaf9106c9c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    rm_r libexec/"lib/node_modules/@shopify/cli/node_modules/clipboardy/fallbacks/linux/xsel" if OS.linux?
    bin.install_symlink libexec/"bin/shopify"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shopify --version")

    assert_match "app build", shell_output("#{bin}/shopify commands")
  end
end
