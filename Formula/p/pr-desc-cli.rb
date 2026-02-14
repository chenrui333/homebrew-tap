class PrDescCli < Formula
  desc "AI-powered PR description generator"
  homepage "https://github.com/chalet-dev/chalet"
  url "https://registry.npmjs.org/pr-desc-cli/-/pr-desc-cli-2.0.3.tgz"
  sha256 "59cb6fbe61187b100db447ebc550f933c527f543245aedbcbf8379b1ee4bce78"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "cb158fc5e9492a39515577b402cc578c6a390b54a144065ce1f4ab3860b6b7ef"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pr-desc --version")
    output = shell_output("#{bin}/pr-desc models")
    assert_match "llama-3.3-70b-versatile", output
  end
end
