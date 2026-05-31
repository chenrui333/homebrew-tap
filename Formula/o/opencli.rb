class Opencli < Formula
  desc "Make any website or Electron App your CLI, AI-powered"
  homepage "https://github.com/jackwener/opencli"
  url "https://registry.npmjs.org/@jackwener/opencli/-/opencli-1.8.1.tgz"
  sha256 "662182fbb62d37d34064db48e0108d216ea1b8363ba43d8e1bb927346a07e567"
  license "Apache-2.0"
  head "https://github.com/jackwener/opencli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "d0a0a6859b1eadb2de2e28e6b20b303e8abb3019b68ff24f9c3fa33acabea399"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencli --version")
    assert_match "opencli", shell_output("#{bin}/opencli --help")
  end
end
