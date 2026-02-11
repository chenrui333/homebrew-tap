class TavilyMcp < Formula
  desc "MCP server for Tavily"
  homepage "https://github.com/tavily-ai/tavily-mcp"
  url "https://registry.npmjs.org/tavily-mcp/-/tavily-mcp-0.2.16.tgz"
  sha256 "333cd2ad1fd31a8219cba53528fcc6d03800eb074c20d0e185bc07083ee05721"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "e9790e06a84b0ae19b5a08bda8370421e4e2f5b60f54387f6b4e2f109fd211ec"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["TAVILY_API_KEY"] = "test"

    assert_match version.to_s, shell_output("#{bin}/tavily-mcp --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "using Tavily's AI search engine", pipe_output(bin/"tavily-mcp", json, 0)
  end
end
