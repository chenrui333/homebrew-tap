class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.635.tgz"
  sha256 "a0416c79e6d4faf22a9664ba381430006e3716b8c98bf814f8bd4d3ba22cbb41"
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
