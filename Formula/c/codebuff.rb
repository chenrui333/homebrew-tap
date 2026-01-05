class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.569.tgz"
  sha256 "ddd56a7d7c081c71f1bf03136c9eee76e69f7a79ae6af8831c9ab97da44d6fe1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "acc054cc6139aea13ef4bfd1e7740bd8b48f4ffac2c1eb73d3361d38e789417e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cb --version")
  end
end
