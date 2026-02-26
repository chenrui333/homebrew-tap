class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.622.tgz"
  sha256 "ee34c487ddcfe2e2976d4ddbcb60976909f225c001f98ca6fe5662f3975e01dd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "3f0f103df3b06a9d99a13ed6900c641190d5175d12b8aacd8dd364427d344710"
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
