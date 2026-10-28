class CreateMcpUseApp < Formula
  desc "Project scaffolding tool for mcp-use applications"
  homepage "https://github.com/mcp-use/mcp-use"
  url "https://registry.npmjs.org/create-mcp-use-app/-/create-mcp-use-app-2.1.1.tgz"
  sha256 "44b637c05583513d3e1594cf2e8e26c38bd448ba2fc934ae652bfe4f2bd90add"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "9c3bc9a2c93ba0609c5d34f7b1a5065314647949c26dfa3d415f5b77b18cbc2f"
  end

  depends_on "node"

  deny_network_access!

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/create-mcp-use-app --version")

    # create a test app
    system bin/"create-mcp-use-app", "test-app", "--template", "starter", "--no-install", "--no-skills",
           "--sdk-version", "1.34.0"
    assert_path_exists testpath/"test-app/package.json"
  end
end
