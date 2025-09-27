class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.19.tgz"
  sha256 "ab604cffaae99acc0f48ca3453b16b60f5c5bbf2c891aa5f7c508456fc25de72"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f1b921c00ad0b0e965690f52dcc55213b4340cf2e12afbf670c72172cf68a76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d09ecf967cf831d5843b66494a3d55cd48d82cc0fd27503a953f66ad5460a697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f265e28920b29cd5a6b3e14fc158bd414ea5a74cc3bf22f359b10422c36b844"
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
