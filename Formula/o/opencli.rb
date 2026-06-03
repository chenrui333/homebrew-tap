class Opencli < Formula
  desc "Make any website or Electron App your CLI, AI-powered"
  homepage "https://github.com/jackwener/opencli"
  url "https://registry.npmjs.org/@jackwener/opencli/-/opencli-1.8.2.tgz"
  sha256 "4dfcb70626b08de0f9ab286f35e5f570ccb9724396dde165f498f7c14f2b90bd"
  license "Apache-2.0"
  head "https://github.com/jackwener/opencli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "72821f08e8878d7c4808b97ac0472563fc4f6172ce027fa72c596154b1664fdc"
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
