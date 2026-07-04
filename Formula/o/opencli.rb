class Opencli < Formula
  desc "Make any website or Electron App your CLI, AI-powered"
  homepage "https://github.com/jackwener/opencli"
  url "https://registry.npmjs.org/@jackwener/opencli/-/opencli-1.8.6.tgz"
  sha256 "d271cf3ebab40dfd85c77d328592c8c34d6df20ff2aee9b641f984740d3c6670"
  license "Apache-2.0"
  head "https://github.com/jackwener/opencli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "d28e2a09d6bf79242f3f9b2ab62ca582aa717ec7d9ae193aa39729e56c8e0eaa"
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
