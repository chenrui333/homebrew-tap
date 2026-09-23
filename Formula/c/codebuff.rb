class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.688.tgz"
  sha256 "39b430fdb9c21de80d4c08d152a935abf5f83de14fb039880b9c2b669b228483"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "9207ba6761cfda65d5417aa1a43627323be742c01cfe501ea03c5611a241a32b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match(/\b\d+\.\d+\.\d+\b/, shell_output("#{bin}/cb --version"))
  end
end
