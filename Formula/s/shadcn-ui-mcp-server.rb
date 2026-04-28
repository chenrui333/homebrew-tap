class ShadcnUiMcpServer < Formula
  desc "MCP server for Shadcn UI v4"
  homepage "https://github.com/jpisnice/shadcn-ui-mcp-server"
  url "https://registry.npmjs.org/@jpisnice/shadcn-ui-mcp-server/-/shadcn-ui-mcp-server-1.1.0.tgz"
  sha256 "4aeb3400a746f1e37c9b5960b605adf978fee1f84cb8262ccd2aa9f4e79740e9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d361aa38c1e4cdce6c3572fcb3a5c0a90db39604eb1ab4f157fcba94d3a5d8bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08d6911b877e565edd923788518f88a9df9a21cdefd0a1b0a302351a4275674b"
    sha256 cellar: :any_skip_relocation, ventura:       "079852ce17585df177887f963658874f3e3469b00b885fb4f0b8de3c3401e52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdef32102a261fd88db2601d2af3e05d230cecd46bce21b59afc09949164fd7f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/shadcn-mcp" => "shadcn-ui-mcp-server"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/shadcn-ui-mcp-server 2>&1", json, 0)
    assert_match "No GitHub API key provided. Rate limited to 60 requests/hour", output
    assert_match "Get the source code for a specific shadcn/ui v4 component", output
  end
end
