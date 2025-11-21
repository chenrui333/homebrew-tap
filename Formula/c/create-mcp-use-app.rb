class CreateMcpUseApp < Formula
  desc "Project scaffolding tool for mcp-use applications"
  homepage "https://github.com/mcp-use/mcp-use"
  url "https://registry.npmjs.org/create-mcp-use-app/-/create-mcp-use-app-0.5.2.tgz"
  sha256 "c31ca2bd8c2ff767f300ab3d12286f82fca18045efad75f89975944ae9103773"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ae9edc3de930900cfb313c6d1767beb170d7b27a27a2f5d83cce55f25948b409"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/create-mcp-use-app --version")

    # create a test app
    system bin/"create-mcp-use-app", "test-app", "--no-install", "--no-git", "--template", "starter"
    assert_path_exists testpath/"test-app/package.json"
  end
end
