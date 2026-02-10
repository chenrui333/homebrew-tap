class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.616.tgz"
  sha256 "2556cd0ce2cfc4484f68f9241f92ace299089c1ec8c48e945daeb6f78389d1fe"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "998af33a07c555329bdc866c3d4899c602e5da6a43b699e1208c804e96e0c012"
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
