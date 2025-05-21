class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.80.4.tgz"
  sha256 "ebb21b9fd9128da58a2f11dbe0f2784e3892f5a5fa33c7fd495a47099878482c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "4a6b989f939296e00079bc7bee68371c0f4d146251d1b93612d2ea7a48b96d6f"
    sha256 cellar: :any,                 arm64_sonoma:  "b98fb2fa35fd7ba6f315c402630b449a2d275a66725cc84e3189ee35fc253cbc"
    sha256 cellar: :any,                 ventura:       "2247a3ae667ba95a74bb19b5a0ade6b3d7192bcd94aa3d34dd49b9e655d6efba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54d939b8917b418dd43b0f212064b71972d02d8f71a627de7847c9e11e5838a5"
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
