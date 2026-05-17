class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.677.tgz"
  sha256 "f8f25198a0f9ea064cfc601c3334a27b9eef17ba721e6e9aeebfed56272cb851"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "d9efa7c35aa76d1266d7a1b50d6da60cff362db09a485ef41e1a7a1b1543df90"
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
