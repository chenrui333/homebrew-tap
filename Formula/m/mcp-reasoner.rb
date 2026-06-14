class McpReasoner < Formula
  desc "MCP server for beam search and thought evaluation"
  homepage "https://github.com/Jacck/mcp-reasoner"
  url "https://registry.npmjs.org/@mseep/mcp-reasoner/-/mcp-reasoner-2.0.0.tgz"
  sha256 "cf03037abee12121e720fa38bf04983d3729c1f01af525a555aba3c21fa86084"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    (bin/"mcp-reasoner").write <<~SH
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" \
        "#{libexec}/lib/node_modules/@mseep/mcp-reasoner/dist/index.js" "$@"
    SH
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"1.0"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    output = pipe_output(bin/"mcp-reasoner", json, 0)
    assert_match "\"name\":\"mcp-reasoner\"", output
    assert_match "\"strategyType\"", output
  end
end
