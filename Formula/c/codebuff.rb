class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.534.tgz"
  sha256 "c6152a5ce1e19aeb20cffc00600015f794d73be854a89c15b710d74120d27a64"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "45c9064312b78a66c2d50e7da0e8837ebdb6b59b66cc70260638e224c5b07ede"
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
