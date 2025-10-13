class BrowserbaseMcpServer < Formula
  desc "MCP server for AI web browser automation using Browserbase and Stagehand"
  homepage "https://github.com/browserbase/mcp-server-browserbase"
  url "https://registry.npmjs.org/@browserbasehq/mcp-server-browserbase/-/mcp-server-browserbase-2.1.3.tgz"
  sha256 "35a47d60a656b044512560914a4504318a8e13195a337d7fce54d9962f403ccc"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "a97f40afb65061c86c3d1331ab177ae7d9bafca882b4599d6116123d865b95fc"
    sha256 cellar: :any,                 arm64_sonoma:  "ec1327ec054ad64a03904040480948120b1bea7bf5162f4cd82fde3770120dfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fecbae97537e847fb8d9e6b347494607fd3a87a6bf088acd018e0def99ea33f9"
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
