class McpServerTester < Formula
  desc "CLI-based tester for verifying that MCP servers"
  homepage "https://github.com/steviec/mcp-server-tester"
  url "https://registry.npmjs.org/mcp-server-tester/-/mcp-server-tester-1.4.1.tgz"
  sha256 "5941077555e91ae5cb21dcec7d7cb9b9e03e07bc24f62c7c4384400b1a5d43fb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9f3fc6333836b02e97b5437f13504b57f4065e5c6db3c2c6abc6c5a1f5f6d59e"
  end

  depends_on "patch-package" => :build
  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-server-tester --version")
    output = shell_output("#{bin}/mcp-server-tester schema")
    assert_match "Schema for MCP unified test configuration files", output

    output = shell_output("#{bin}/mcp-server-tester documentation")
    assert_match "The MCP Server Tester is a tool for automated testing of MCP servers", output
  end
end
