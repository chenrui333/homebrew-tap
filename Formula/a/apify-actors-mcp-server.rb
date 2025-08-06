class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.3.6.tgz"
  sha256 "1589e19802e56e75a7bdb3baa4ac2ac50e83883f0ea884b01cfaefea57a3bc32"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69607666d8b5d85f41dd0863f08676d61bf3519b081944837fbc3111906fd789"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20b0439e1a2cbc4da9e602ade4c40870fcc4886d8f007101f2291e5a881df5fe"
    sha256 cellar: :any_skip_relocation, ventura:       "48b532c75666f272059c52e7bbadd0b62d6e4a6ed177ec31be806734e98181c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78506e72b4b14dc1e477976491132810aaa491f5b1a8922eaec019a42cb6ca22"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["APIFY_TOKEN"] = "test_token"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/actors-mcp-server 2>&1", json, 1)
    assert_match "User was not found or authentication token is not valid", output
  end
end
