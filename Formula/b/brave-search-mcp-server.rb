class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-1.3.7.tgz"
  sha256 "2b636d7fc369544d798b9f34ac038e60a32edbcd5302cfc8552b727d76877b1d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f36f2bdfec9bedde522bb7cd65e95b25644bb92330802a66980ea7f127bdfe48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "868da276238f910ef68c4b8715bd6f0c73b442ee6cc5f787be20aaa0778bde54"
    sha256 cellar: :any_skip_relocation, ventura:       "2f41d187b06921fa3f6a99b04667e062c2ba774fe4d571d4f24302d145c618cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa45b123b2b093d9f4d3bd0bfe17106bd09bbc7c5111a7b68d34fe399ea72fd5"
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
