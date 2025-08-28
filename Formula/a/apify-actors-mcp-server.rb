class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.4.tgz"
  sha256 "54dc761b8cb5164218b5e2446d54dc5676ff16418629424162570d8f9058350f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d18b67e8d5a3e41d05a9d4c66b89f9355da146f93505da5850f033e012bc49d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6732bc1348c90cf1412d6a9eed5725ae6d5f7f4456125f94c5ea657806020e29"
    sha256 cellar: :any_skip_relocation, ventura:       "9c4ea38ed18dfdbb75dec0bd88fd22856d4e0f9948ac4b4fd937d958df5125fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae37df771dd5a14ca35ba25fed5109474cee4f0ff4b30dac575164b0f1475241"
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
