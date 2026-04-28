class LibrarianMcp < Formula
  desc "MCP server that gives Claude a librarian for your Obsidian vault"
  homepage "https://github.com/ngmeyer/librarian-mcp"
  url "https://github.com/ngmeyer/librarian-mcp/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1e93fae534c93621f0e9f298f56241f0ca5998a08f4d25a0975298daadf6ce38"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/librarian-mcp --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"Homebrew","version":"1.0"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{"cursor":null}}
    JSON

    output = pipe_output("#{bin}/librarian-mcp #{testpath} 2>&1", json)
    assert_match "library_search", output
  end
end
