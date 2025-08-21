class TwilioMcpServer < Formula
  desc "MCP server for Twilio"
  homepage "https://twilioalpha.com/mcp"
  url "https://registry.npmjs.org/@twilio-alpha/mcp/-/mcp-0.7.0.tgz"
  sha256 "7ff791d1023cad6372496d8aba1c49bc3ffbcf0989b9f96b3a83d2df9d6af755"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"twilio-mcp-server", json, 1)
    assert_match "Invalid AccountSid", output
  end
end
