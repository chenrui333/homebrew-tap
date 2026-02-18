class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-0.16.2.tgz"
  sha256 "1a00dad9149e5afc473e1eb562febd836845f4b5ec2cf7183cf3c26c4e917fa8"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "9a6433b1c6e381234f4103c9365b6eb35e3486019ccf4f61631cb64a7f2fb62d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/auggie --version")

    assert_match "Total: 14 tools", shell_output("#{bin}/auggie tools list")
    assert_match "You are not currently logged in to Augment", shell_output("#{bin}/auggie model list 2>&1", 1)
  end
end
