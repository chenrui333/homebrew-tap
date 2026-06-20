class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-0.30.0.tgz"
  sha256 "5905f46c087dc2f9185fb4fa5af5c6afb4415f21759ab4a5ea20bd56c613344f"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "633e895174466fa8fa1b80a2edf9ffc5958528e3fd67e559a4a99d34c56a1603"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/auggie --version")

    tools_output = shell_output("#{bin}/auggie tools list")
    assert_match "Total:", tools_output

    model_output = shell_output("#{bin}/auggie model list 2>&1", 1)
    assert_match "not currently logged in", model_output
  end
end
