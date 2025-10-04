class McpServerAirbnb < Formula
  desc "Search Airbnb using your AI Agent"
  homepage "https://www.openbnb.org/"
  url "https://registry.npmjs.org/@openbnb/mcp-server-airbnb/-/mcp-server-airbnb-0.1.3.tgz"
  sha256 "0a7e5db6a14807987c49667f8c8cb17e81fadef5b4e0a3f3fa03ea78d788ec6e"
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

    output = pipe_output("#{bin}/mcp-server-airbnb 2>&1", json, 0)
    assert_match version.to_s, output
    assert_match "Location to search for (city, state, etc.)", output
  end
end
