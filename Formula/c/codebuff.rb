class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.634.tgz"
  sha256 "ca0b1f9e1513a0fdfde0c0bd41df0f35389df42244b6744c44e9ad2c7fb6d6a1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "46060adb97cc1d8c1cb7807fa6df5d1fba5ddab705bb395378c3cd7d59fe7499"
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
