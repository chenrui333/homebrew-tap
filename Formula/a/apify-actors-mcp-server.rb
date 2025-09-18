class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.12.tgz"
  sha256 "e78e093ff1da31d6a30ae5e0ecb3c82f84878c8b8dfb5ce300970cc0e34d42f1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a834464e768e5736b3060cda9d50bec39d957774b7da259c86ef89554694250c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81ae50ed47ebdb8af97bd8d2a2f63bbd04e03eb540469cdbfe01406824221757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe7a89dcddfd7b5612c0bf87e7376bcb1b86597fc988e05b2afcccc4e3f568ea"
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
