class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.19.tgz"
  sha256 "da286c7899937951f8f544b7bed29ac2322abcefcc18dbfacbd6c0d90f3b7a1d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff21b025ed731c1c2e6e8e54b8faba7a162712fa847293a2e1080da99009effa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68625f39b5270a1f86cb2c37237f193e2c7e20c0d15a5ba774c6cf88923d738e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46c21c193f1bc350a4bfcbf94285472ce3b12ca4d9865ed7499bb89c72cc89ef"
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
