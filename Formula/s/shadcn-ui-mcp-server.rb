class ShadcnUiMcpServer < Formula
  desc "MCP server for Shadcn UI v4"
  homepage "https://github.com/jpisnice/shadcn-ui-mcp-server"
  url "https://registry.npmjs.org/@jpisnice/shadcn-ui-mcp-server/-/shadcn-ui-mcp-server-2.0.0.tgz"
  sha256 "f8a0337d22b6c5bdcf4ed8524605509ded814ffa6620013ef3677f9b43d4f1b7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "3fc396ed670e3be98f7f1629ba54d0300ebdaf77e198cd0b1e4baa106d081db5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/shadcn-mcp 2>&1", json, 0)
    assert_match "No GitHub API key provided. Rate limited to 60 requests/hour", output
    assert_match "Get the source code for a specific shadcn/ui v4 component", output
  end
end
