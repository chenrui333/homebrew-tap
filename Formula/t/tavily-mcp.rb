class TavilyMcp < Formula
  desc "MCP server for Tavily"
  homepage "https://github.com/tavily-ai/tavily-mcp"
  url "https://registry.npmjs.org/tavily-mcp/-/tavily-mcp-0.2.11.tgz"
  sha256 "808c49910f807495a9bfde904719434dce0115edda126ebc132a4e7f6490673b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33ac925b7cc0c2b8a3e20581b244d2d6fddb7ee429a57566e199fd1e35918b8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "648830e583c943562c52368688b38bd18aa02335ebc42ae0bcb9bae704fd3c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83e8e4c152e23a173c0433e47fab62cf40d22db8238e4e0403571f71a369aef7"
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
