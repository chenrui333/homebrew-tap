class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.636.tgz"
  sha256 "43444a57a2f1a3e578905e13e091088387fa38913143fdb7f342d3d114bd18b2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "da44502b7a9e9d82afec909e155c0e4b56250ccb8463d86fc3dab73771b5c141"
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
