class AzureMcp < Formula
  desc "MCP Server for Azure"
  homepage "https://learn.microsoft.com/en-us/azure/developer/azure-mcp-server/"
  url "https://registry.npmjs.org/@azure/mcp/-/mcp-0.5.1.tgz"
  sha256 "f26f99f92cbf5d463fc718ed1c036578da422a43117bd33aa828185185899329"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azmcp --version")

    rpc = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    assert_empty pipe_output("#{bin}/azmcp server start", rpc, 0)
  end
end
