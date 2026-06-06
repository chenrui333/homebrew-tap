class Opencli < Formula
  desc "Make any website or Electron App your CLI, AI-powered"
  homepage "https://github.com/jackwener/opencli"
  url "https://registry.npmjs.org/@jackwener/opencli/-/opencli-1.8.3.tgz"
  sha256 "21869cfae0782ce3787625dc45541e2864e71ca9d3fe5286f9da3b016843a540"
  license "Apache-2.0"
  head "https://github.com/jackwener/opencli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ac00f9b0837eefbaea20bb5a78285bafe660eff637f639ffc0533f8f9da36ea4"
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
