class BrowserbaseMcpServer < Formula
  desc "MCP server for AI web browser automation using Browserbase and Stagehand"
  homepage "https://github.com/browserbase/mcp-server-browserbase"
  url "https://registry.npmjs.org/@browserbasehq/mcp-server-browserbase/-/mcp-server-browserbase-2.3.0.tgz"
  sha256 "50cbed5f096f035988701a73a01d16fdfffb68cb62d7bf7bb8713c1a82217128"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "e81deb3e096718ae59173a17988ee5688bb7e34437fd53b48408103065c44595"
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
    assert_match "Create or reuse a Browserbase browser session and set it as active", output
  end
end
