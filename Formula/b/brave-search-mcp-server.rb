class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.51.tgz"
  sha256 "d037fbb8315145a73b54faa610dee7996d8c6c94e0d4cd12e616db0e38882975"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5040309393d6ba07ebcd6c0e675cefaf43fb8c9096caaeb30c2746e4cd0a502"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9cbcc07e07b0dd593dced41282d56f151090a2cf98b277485ceee825be20811"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30a96826a8a626dc3e81cc1b5863cba642eada28380f33e3543b531404600a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e1d0462a5633424c9784954ac7134605c350dddebbaa1ae3d5d2dff443ec79c"
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
