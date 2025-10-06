class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.38.tgz"
  sha256 "02bec1c5b501d72dc84abffb0a6a5c16567468a2d7f40059dfabb085c6296017"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c867bc4d80fcc42df9e7cda09e3ea1bd5e5c241ae15c7a5396afe78152bb9f46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d1a44c1689dc443ee1d40fd2499e825fcc541cbe9a3ec71f1b7c9af823f7537"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ec454f6aa7bd1e472985174a28431fccd69b67a404096fff2c966af0cd3dcb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0adc484325712ff7b02f24cac94fa663a992aca647b46a8efacf060754faff68"
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
