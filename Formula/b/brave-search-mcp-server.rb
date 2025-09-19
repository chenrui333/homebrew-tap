class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.6.tgz"
  sha256 "4a9e185262d2f434f18659c1146f73bee6c0bc666e51306de154717798168399"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f7d66f22e8d46bf45443d1ba42632c4d6bd9abe8d9062013a0afd58a8eed78d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bcda5adcf889a36cba9daccb8a5626d6d4bbc0fb61ceb3b498b654bb9276f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8729bb52a76051102e061b82561e6b250c6e09ad5a79088c7340aa68debb86df"
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
