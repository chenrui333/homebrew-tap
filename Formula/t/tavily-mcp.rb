class TavilyMcp < Formula
  desc "MCP server for Tavily"
  homepage "https://github.com/tavily-ai/tavily-mcp"
  url "https://registry.npmjs.org/tavily-mcp/-/tavily-mcp-0.2.22.tgz"
  sha256 "ac1aaffea2131d87d51c5229195d62d61c081f7bc762024c00af0faf48b8eacf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c225db16c0ecf96fa4c96d0905b7e3cd6fef25039fed7c5570000e0aed02b467"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25cd32e8d15b07b6e36f42c753b29249cbc05d01da737660640811e81906dbc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7903f18a4c2010df5b73befad4608300a03e25c18dadd838a29304cf0c6986f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25cd32e8d15b07b6e36f42c753b29249cbc05d01da737660640811e81906dbc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25cd32e8d15b07b6e36f42c753b29249cbc05d01da737660640811e81906dbc5"
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
