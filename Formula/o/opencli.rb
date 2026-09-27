class Opencli < Formula
  desc "Make any website or Electron App your CLI, AI-powered"
  homepage "https://github.com/jackwener/opencli"
  url "https://registry.npmjs.org/@jackwener/opencli/-/opencli-1.8.8.tgz"
  sha256 "68fb69d6dcfbcb1f76da88278b499abe322dcca712f3b79fe01729cb63ae6d7a"
  license "Apache-2.0"
  head "https://github.com/jackwener/opencli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "32d67ee367a69b8c2c0c16b394a0a3b7bbcc0912d2edb2e250d5ebd1120b60ed"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencli --version")
    output = shell_output("#{bin}/opencli --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end
