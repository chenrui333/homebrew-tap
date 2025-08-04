class HtMcp < Formula
  desc "Pure Rust implementation of MCP server for headless terminal"
  homepage "https://github.com/memextech/ht-mcp"
  url "https://github.com/memextech/ht-mcp.git",
      tag:      "v0.1.3",
      revision: "df9e4192db026850bc13661ffada1b4c65a3e4fa"
  license "Apache-2.0"
  head "https://github.com/memextech/ht-mcp.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new HT session", pipe_output(bin/"ht-mcp", json, 0)
  end
end
