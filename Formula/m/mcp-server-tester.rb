class McpServerTester < Formula
  desc "CLI-based tester for verifying that MCP servers"
  homepage "https://github.com/steviec/mcp-server-tester"
  url "https://registry.npmjs.org/mcp-server-tester/-/mcp-server-tester-1.4.0.tgz"
  sha256 "ac195741b7eccbaeaf23590c401b548024c6beb95bf1c3ccf0d5c1dec1e45786"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c874b459e31beefdda22cabae87a325e1acd5a72a3675a30a64270ea2c6739d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc750f0919d0b5edbb97678d5b74e77ac1f005d0686b4db6cbbbda6425725d5f"
    sha256 cellar: :any_skip_relocation, ventura:       "76d1d99d4d6676abb5db556a6d891d5e36ec5665253c0ee2f392b1e3d73f0abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc8e633a5aae7dd3320f6d372f1688ce139cdab3eadc719120ba3b6b6aeec2f8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-server-tester --version")
    output = shell_output("#{bin}/mcp-server-tester schema")
    assert_match "Schema for MCP unified test configuration files", output

    output = shell_output("#{bin}/mcp-server-tester documentation")
    assert_match "The MCP Server Tester is a tool for automated testing of MCP servers", output
  end
end
