class BrowserbaseMcpServer < Formula
  desc "MCP server for AI web browser automation using Browserbase and Stagehand"
  homepage "https://github.com/browserbase/mcp-server-browserbase"
  url "https://registry.npmjs.org/@browserbasehq/mcp-server-browserbase/-/mcp-server-browserbase-2.0.1.tgz"
  sha256 "0b720b596113f4640aa27d5e7339bcfb3da4ba21182c72179735267d44170c12"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_sequoia: "095a228a553f747403c381c211b7f3773db0d245cd13070f2dff57ec9aeb46ac"
    sha256                               arm64_sonoma:  "392fdb1de6e3fa5ad9ae57a1ee2b29fc2f7f122a7955d5f75e786fb15dd57e41"
    sha256                               ventura:       "95c1e4eb597c82bb83a0406c98b05892e72098ff95ee4137fdb38bdee9a2e528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a127ffd9f16f650e145cfc60d04152c982d75e1f5c93cda019c4f90d008d8b35"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
    mv bin/"mcp-server-browserbase", bin/"browserbase-mcp-server"
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
