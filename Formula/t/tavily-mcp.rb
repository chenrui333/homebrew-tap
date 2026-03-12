class TavilyMcp < Formula
  desc "MCP server for Tavily"
  homepage "https://github.com/tavily-ai/tavily-mcp"
  url "https://registry.npmjs.org/tavily-mcp/-/tavily-mcp-0.2.18.tgz"
  sha256 "1e2e40d089e43e3d0af387deb037cd626733643fdaf14fadf693288d9111a768"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "509f7c9d4506527ff8d86a798178b2b41f71ebb2c261790b69c6afde17c63571"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["TAVILY_API_KEY"] = "test"

    assert_match version.to_s, shell_output("#{bin}/tavily-mcp --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Search the web for current information on any topic", pipe_output(bin/"tavily-mcp", json, 0)
  end
end
