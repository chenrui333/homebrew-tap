class NotionMcpServer < Formula
  desc "MCP Server for Notion"
  homepage "https://github.com/makenotion/notion-mcp-server"
  url "https://registry.npmjs.org/@notionhq/notion-mcp-server/-/notion-mcp-server-1.9.0.tgz"
  sha256 "a047243d0f6d68556feaa54cb709e65211a230bdbfcfeeab88be572e53833822"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd3af01da155b4df7ded86997126cb86a0b7f35f378cc83a176461c4642fc4ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "288653a944b036be12f5290ee7d0c7dd919b422787c02fa64eacfc41f23a82c8"
    sha256 cellar: :any_skip_relocation, ventura:       "32d73ee59779901a2b9a622b7e854a65f4598576b5d1b669e1e604273b9c9037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "729faa52961092407d097cabf445b5d4cdbc15558a9d6fd89bc7dca103907477"
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

    assert_match "Identifier for a Notion database", pipe_output(bin/"notion-mcp-server", json, 0)
  end
end
