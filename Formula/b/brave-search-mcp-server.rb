class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.30.tgz"
  sha256 "6821401d050a4e6617560728bfacb77377c00bbc6498fbc5649b67eb8896affa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "080732c726526b7e99d03d9c32a5e0c65af5c56fd0a177493f4742ef7dc7a063"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76778e040e12dddaad205a17d79a57c85d116f3932b0938d1e519a98ce93df0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff10721684329d9c07f1fa7ed079d468a299229491f9bc68f6bcbf2d7e77e0c"
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
