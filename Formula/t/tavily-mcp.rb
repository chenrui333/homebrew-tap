class TavilyMcp < Formula
  desc "MCP server for Tavily"
  homepage "https://github.com/tavily-ai/tavily-mcp"
  url "https://registry.npmjs.org/tavily-mcp/-/tavily-mcp-0.2.22.tgz"
  sha256 "ac1aaffea2131d87d51c5229195d62d61c081f7bc762024c00af0faf48b8eacf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "362d93a5c86a23ff1e48cb68baf520b1a54d87a71604753c867dacd084c8d9e2"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
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
