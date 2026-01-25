class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.598.tgz"
  sha256 "541d09a6d89c6a9d2f3ceebd4448d42d3e62c059c63a5c6d5fdc7b778d0ac6a3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "b387f9b3f9c94afe5b15393ae6a08a8e2f7945014ee06160363742458e3a7db7"
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
