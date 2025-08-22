class SupabaseMcpServer < Formula
  desc "MCP Server for Supabase"
  homepage "https://supabase.com/docs/guides/getting-started/mcp"
  url "https://registry.npmjs.org/@supabase/mcp-server-supabase/-/mcp-server-supabase-0.4.5.tgz"
  sha256 "8b6aa29dbfdd6b719cda7836920f322f07a2820bf486a9d89e855b7d01ea38ad"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4c1e63902951b608e18defd4f849629fccbed309a9b0d303c68edbadf178b02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfc4bf935f8ca5fab47189404765a7f4789dad8b4a651ede243f33b31cc8e3f8"
    sha256 cellar: :any_skip_relocation, ventura:       "4210e6489a2507e90b0103ebd6dc3b4ae96f6bf4b26608c3b33e3af857c33fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6788bc79f67aecb6dc4c6fb09222d55571e79432096a7b4e9b4b7c9bffa89974"
  end

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
