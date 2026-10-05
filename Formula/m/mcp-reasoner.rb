class McpReasoner < Formula
  desc "MCP server for beam search and thought evaluation"
  homepage "https://github.com/Jacck/mcp-reasoner"
  url "https://registry.npmjs.org/@mseep/mcp-reasoner/-/mcp-reasoner-2.0.0.tgz"
  sha256 "cf03037abee12121e720fa38bf04983d3729c1f01af525a555aba3c21fa86084"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11afad8907219dd8dda1ee417b397c94dafd286c23bc19b79d072185f176ea4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11afad8907219dd8dda1ee417b397c94dafd286c23bc19b79d072185f176ea4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38331cde77d9b433de6c83720b86164a822f36a079e37bad0aca47219fe11700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38331cde77d9b433de6c83720b86164a822f36a079e37bad0aca47219fe11700"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args

    (bin/"mcp-reasoner").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" \
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
