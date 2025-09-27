class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.28.tgz"
  sha256 "e9706cd54acd7d80c1656640662598314432eca847b858571df5ab4dc9d914cc"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  # test do
  #   json = <<~JSON
  #     {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{}}}
  #     {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
  #     {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
  #   JSON

  #   output = pipe_output(bin/"hf-mcp-server", json, 0)
  #   assert_match "Query timeseries points of metrics from Datadog", output
  # end
end
