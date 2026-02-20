class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.620.tgz"
  sha256 "3f9712b5a89871f474b2bc763c16eb1d9e47f2a9c7bcfb098e22853949d2a34d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "74caeedc7ac6ca032aaa723220941a7cbacbd71aa8ecbc8925e18a91d6dcad34"
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
