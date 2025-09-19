class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.13.tgz"
  sha256 "20e148a5159f93fb300e6d5a14793bbf562ec5d7cb08133e885da7e78cf2165e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e475e581158ed225765a148c5d0f706fd608b4f7d4e44d7c33156ecc51fde8f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c39dc04021a6ad30c6e783385f018f85318c088dec8c170c62dd19c05f6d4ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c44dfdf4f230453a9fdb5cc682f8dfdf69598460137f2df288ff500cbab92d3"
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
