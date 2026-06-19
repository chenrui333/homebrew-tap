class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.682.tgz"
  sha256 "b7bae5d6db4d3eab0f5ce6a9d3b78c7e729bd147c75e587ca587dea6ce3f3dda"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "149d41790f292082882f56d85a814e88c2f0962109a8c93cfb231df998198b87"
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
