class TavilyMcp < Formula
  desc "MCP server for Tavily"
  homepage "https://github.com/tavily-ai/tavily-mcp"
  url "https://registry.npmjs.org/tavily-mcp/-/tavily-mcp-0.2.9.tgz"
  sha256 "eef1ad5ea664832b45d309f3c6d784489bf9c1cf14f3e517c21c293cae799497"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9050e8f3c17c997930c1b14b72d8950bfd10dff824bc4803e3af2961d400720"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef9222a81c3898c9f2a4756f3c56f0794699f3d7801c2c899a565f88258f89dd"
    sha256 cellar: :any_skip_relocation, ventura:       "31bc55f677a8ff2968d25b5295892aef9779b1ec7868a3843c1e127a9cb8872e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52176cc31f31d1e9a402b7c133774fbec15504555132fc3a3e9d84246eae030a"
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
