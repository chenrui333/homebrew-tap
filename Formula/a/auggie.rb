class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-0.22.0.tgz"
  sha256 "bc7c7523e424ae08df25b1b06f8b405fdfa4fad3e1e38486a8693a9de93cfce3"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "3e3f53b154f0b3021d82da409b758b41d965c6da38002ee2741730b0f837f510"
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
