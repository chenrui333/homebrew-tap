class CreateMcpUseApp < Formula
  desc "Project scaffolding tool for mcp-use applications"
  homepage "https://github.com/mcp-use/mcp-use"
  url "https://registry.npmjs.org/create-mcp-use-app/-/create-mcp-use-app-0.14.14.tgz"
  sha256 "8c0924548f8612123417d3dedd00aacbbac310d6c2976929ed6eb3091c5f0ee3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "1ba03ddbbcd77c569d13ad056c2e3e063c9edd07528eea6cba42d9b2ba0f2395"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/create-mcp-use-app --version")

    # create a test app
    system bin/"create-mcp-use-app", "test-app", "--no-git", "--template", "starter"
    assert_path_exists testpath/"test-app/package.json"
  end
end
