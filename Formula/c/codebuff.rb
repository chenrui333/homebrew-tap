class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.625.tgz"
  sha256 "eafa8e8d14b1ab4b2d368f82a1ecb4e697a7d606065cbb4a06d5e6c30b85ebee"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "8e51c5dbdfb1080c2dba8bca4bba9de6c491bd02da66f2038c5dc7157757aa84"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cb --version")
  end
end
