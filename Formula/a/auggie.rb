class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-0.25.0.tgz"
  sha256 "7ab4f073f7fa90d00bc6f36888ed933a795504eb5d7b26455c5e2a8bd5c0fedc"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "565e2849e0ab46b23aae98c3fe7bd8c84666e3c587b878c0aae40b615dc680f5"
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

    model_output = shell_output("#{bin}/auggie model list 2>&1")
    assert_match "logged in", model_output
  end
end
