class SupabaseMcpServer < Formula
  desc "MCP Server for Supabase"
  homepage "https://supabase.com/docs/guides/getting-started/mcp"
  url "https://registry.npmjs.org/@supabase/mcp-server-supabase/-/mcp-server-supabase-0.4.5.tgz"
  sha256 "8b6aa29dbfdd6b719cda7836920f322f07a2820bf486a9d89e855b7d01ea38ad"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/mcp-server-supabase" => "supabase-mcp-server"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase-mcp-server --version")

    ENV["SUPABASE_ACCESS_TOKEN"] = "test-token"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Lists all Supabase projects for the user", pipe_output(bin/"supabase-mcp-server", json, 0)
  end
end
