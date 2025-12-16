class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.552.tgz"
  sha256 "2f5bf8962f1b5f6e89ccaaadf7c7318e350651cd73cb4a9492b8eb5f41477960"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "1122eb34aefc30059bb26294b5f00f4ebb4cb2f4a58a91f5f3ac2393d98dc7c2"
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
