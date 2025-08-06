class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.3.3.tgz"
  sha256 "8eabcf58c308ce609d0a0e104b72defcf4615924d5885e526841634762c12969"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "381de35aee78bd2a8c4ee7546b7e606dd6e8327c6711970a10d7537151118f97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d452a8c0e499f145834fa90491da79757c93d302a416f8afd2b181eaa1a1798e"
    sha256 cellar: :any_skip_relocation, ventura:       "f906dde58f1533c744e0dce891ce28eeca59040124f1653455f069787547fc9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48fb4dbdcc51884418e04a7267b37e1f8dc850c76002221a9e1a26074fa9937b"
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
