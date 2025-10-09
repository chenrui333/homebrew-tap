class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.23.tgz"
  sha256 "f183267827650f4e806ec0fe51cab928e6cb4d6cb010e5f56b15bb3636ed6ec1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5349fa84ff971db7eea16838d1a7e9d011d68be50a34f90bbfa1def34a98141"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33c08b077d171dfba352b1ff16c062f233e28e83972d6eb775b074621e9c6f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66ebc8dcc692205f0b17cf6a919720a6ecb8fa4ee78556d04508fe4edd770e92"
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
