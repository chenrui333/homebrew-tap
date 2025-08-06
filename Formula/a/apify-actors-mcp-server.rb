class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.3.3.tgz"
  sha256 "8eabcf58c308ce609d0a0e104b72defcf4615924d5885e526841634762c12969"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "586e96c8beb91aee70e6d7b3c509ab18c3abd948dfca66c3af772cfd08beb8b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "161875739460dfeac78d50378c11332f012e0fd7d22d0b398463342edb75ef21"
    sha256 cellar: :any_skip_relocation, ventura:       "1616b9393c06c727d39c951229d4561617c343ae061ac530fad3fb080bf67200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ae01b1d727660a812518c50267a44e8f2d7b2e6f968861908b771e726f597ea"
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
