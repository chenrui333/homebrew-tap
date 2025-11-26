class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.533.tgz"
  sha256 "b0ae2bec4169c955850e327ab4de27246c5a6e001bb27ee5c0bc5371520b94b1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "3c2b62c5ad942e4d6e7a3f96f9a4cf42d4f40e7ae30248d593d51cb9eed9f2c4"
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
