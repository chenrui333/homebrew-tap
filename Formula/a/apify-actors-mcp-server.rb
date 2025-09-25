class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.17.tgz"
  sha256 "0a9166c803ead4d201e1b97cfbac9c91c6d01b5149312016bbb02320c1be6614"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64dd3f3eb9008ab532d529e1e0591584a7e1315de97313427a568eeab28fa2a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcf440ce13e023a827e32d5227f3c36c029b256dab6bde593ab96e019389b361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82ad6bb532b5b3a0a947ba510936194fa1933ff0129fc6c4c11e0d46e6e7ba13"
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
