class TavilyMcp < Formula
  desc "MCP server for Tavily"
  homepage "https://github.com/tavily-ai/tavily-mcp"
  url "https://registry.npmjs.org/tavily-mcp/-/tavily-mcp-0.2.0.tgz"
  sha256 "fbe82a1593c56ea6f2fd52c5774d1a3a53a99bfaf91a1b19ad6e528e49e05e45"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a2ff0583bdb730220e84435f48213cd266f9edb7fc82a78152ec61497ec1c44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00d22dd3ee40ec2a499167a8fa475973e7622226900a4ea1cc45bd57e1186230"
    sha256 cellar: :any_skip_relocation, ventura:       "ae3a2bee50eed43a7b81ea7418de2341be7c3e46b500ef31aeb98c69a9df09d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1961f9e8f7966d0a303f20ce7b0781725388f6ebf2d50971880c01e3f030427c"
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
