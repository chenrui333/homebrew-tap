class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.30.tgz"
  sha256 "6821401d050a4e6617560728bfacb77377c00bbc6498fbc5649b67eb8896affa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aafc779ff318d141e7ad0a0a029c5b2534339d8df49bdff43c96e518dc6fd35d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74b32e8325b4c84307e72cc58fe7c7a6f16ffde8cd1b064991f4fc995e760727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60efd476b8fa437000dd2560eafd04656eb8be5339d06d9fe996b0080e1bb960"
  end

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

    output = pipe_output("#{bin}/brave-search-mcp-server --brave-api-key test --transport stdio 2>&1", json, 0)
    assert_match "Performs web searches using the Brave Search API", output
  end
end
