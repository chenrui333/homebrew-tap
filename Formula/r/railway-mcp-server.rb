class RailwayMcpServer < Formula
  desc "MCP server for Railway"
  homepage "https://github.com/railwayapp/railway-mcp-server"
  url "https://registry.npmjs.org/@railway/mcp-server/-/mcp-server-0.1.1.tgz"
  sha256 "d640576a98f2938b83b3608fa5c4ec7fd72e35c136ee03769016202cf66c4870"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12d8e063e8bb64617ae8be72c20252640ee323cf283e04b0788ae523d10e1a37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdfd6e72d2733e449d4584dcb0b22ea037d9b59798372e4c75548d7e06891645"
    sha256 cellar: :any_skip_relocation, ventura:       "0da3f56e73bdcc43ed1055aa23d00ae7328eeccaa2f4249b3550877b02cb4532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b48a7beabb9335442b35a92535d821f3099ed3787be24b4dedd45ceca38b9c6"
  end

  depends_on "node"
  depends_on "railway"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"railway-mcp-server", json, 0)
    assert_match "Check Railway CLI Status", output
  end
end
