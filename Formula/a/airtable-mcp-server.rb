class AirtableMcpServer < Formula
  desc "MCP Server for Airtable"
  homepage "https://www.npmjs.com/package/airtable-mcp-server"
  url "https://registry.npmjs.org/airtable-mcp-server/-/airtable-mcp-server-1.8.0.tgz"
  sha256 "9f6a03d82ca85b73c6de0c7eb1fdbacda3cae123ae85c51a2d624aed582ff09e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b9de825750af168b8a5727eee97aef9a1e8ea537e86a3269bb2cba3e7d380f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cbc672261fb1ce042ca99b7a32239c31d5e92506d4db99a9b1e689c4ec04c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74b812073c5d4869875fbdbfc2989ecb9ee77bdf3b253d8f7f6d62a06a125c2a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["AIRTABLE_API_KEY"] = "pat123.abc123"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/airtable-mcp-server 2>&1", json, 0)
    assert_match "The name or ID of a view in the table", output
  end
end
