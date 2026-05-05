class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.654.tgz"
  sha256 "1c93b2dbb3ce2478c61f019d41f388aabf19af30e14e44dd2f2b2b03969cfb1c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "a4a7a7f651c1ab2b138ab9ab7603a9141a9fc354c89b668cd56cb2630ad7d999"
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
