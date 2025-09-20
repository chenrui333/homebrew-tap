class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.15.tgz"
  sha256 "2403b39eabaf4907290117e73aca237998eef9e0e79cf775d49c293c192d66f7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09de3f1fe5cf046ea617ec198ac74d1f6a441168c267871e91573177b2cc60b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a71f338437d21ada0c4403229e52d105a696e62b9fd46276d62f88d6567534a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d203ff45659a89dc6233fe8d00f47d2c64178bd619d87bd7f0473fb42f27da1c"
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
