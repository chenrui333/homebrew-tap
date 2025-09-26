class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.18.tgz"
  sha256 "5247b8ccbb2d2a964f4c25ff86adfb9e7abe807c8854a7074a2b53c8658ddf2c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a24834666a52a31c13ed6b2f503bbf010d6fe6626202dd5c447f4150923f5216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47bbfef8f55d3395f9b55ac7591ceac3549fecc7cdb42f5677cf44d1ecd729cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce5793a3c441976268c181b4fde6e0e0d9f6b39aec80d53c66e1e995fb7a8bdb"
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
