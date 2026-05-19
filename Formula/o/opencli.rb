class Opencli < Formula
  desc "Make any website or Electron App your CLI, AI-powered"
  homepage "https://github.com/jackwener/opencli"
  url "https://registry.npmjs.org/@jackwener/opencli/-/opencli-1.7.22.tgz"
  sha256 "8109a73b3033f47b3d8844caf23c6cbf542fada9ab8746641c3a27c7edfa798f"
  license "Apache-2.0"
  head "https://github.com/jackwener/opencli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "b39b2efb8fe7c3932047cfaac0f8d43a211121340ac53868580d5a429cd23d4f"
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
