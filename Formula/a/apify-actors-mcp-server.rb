class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.3.9.tgz"
  sha256 "c1f6cbee80e8bdef4e5f2491335d486b7a87a894a9952587d8ccf659c4a86e9f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cee3ffcfe0cbd394deadf5e9d35976af38a4bfef3c80743350d10f033d28e1f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d75501cb1b504d516e4c896de3177ce4b84cc0b061202666747c67d04a6f527d"
    sha256 cellar: :any_skip_relocation, ventura:       "f0265c06087e5e0a163c1291287967e9e170868eb8926404544e1b9a35c83742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2535a8901d5b83d81fca5ae9366d53fc3fd7226131e154459ae77fbab7b7bbfb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["APIFY_TOKEN"] = "test_token"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/actors-mcp-server 2>&1", json, 1)
    assert_match "User was not found or authentication token is not valid", output
  end
end
