class BrowserbaseMcpServer < Formula
  desc "MCP server for AI web browser automation using Browserbase and Stagehand"
  homepage "https://github.com/browserbase/mcp-server-browserbase"
  url "https://registry.npmjs.org/@browserbasehq/mcp-server-browserbase/-/mcp-server-browserbase-2.1.0.tgz"
  sha256 "683fe2029674beee1a3b0120d789a6d1190c3fa973f22c9287a9365f0cdbcfb8"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256                               arm64_sequoia: "b201eca708197405f6f1c26dd417f494d921225862c753bab40a7b3afcb3ef98"
    sha256                               arm64_sonoma:  "3825ed82ee5343837d36c39ae4764460ce1ee03655f29763489b3e9aceed2edb"
    sha256                               ventura:       "5856de0e263aa85036d4ffbec6251c67304ec82b18035f1f628a94a6ddda8c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "491fc887d8d86e6c8874102e9db3aab7ecd2b036b5f8d12fca7e25c36612307d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/mcp-server-browserbase" => "browserbase-mcp-server"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/browserbase-mcp-server --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"browserbase-mcp-server", json, 0)
    assert_match "Create parallel browser session for multi-session workflows", output
  end
end
