class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.587.tgz"
  sha256 "5f2add5af297c7fa7473baa33fcdb8d15f5065e784b64431ac28761d502f9256"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "5841af02f023bbfb81b24ab8c9d3bc70f0e10b14f5d2e5e85d9a7d70a7547d43"
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
