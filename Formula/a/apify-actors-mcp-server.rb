class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.7.tgz"
  sha256 "427c805905b81f43e1847fc5833da7924ab8332ae33629e21c6470de3118334a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de54694c0b0d4a3b34afa62d26ebc328d002e3faaeb81a31f69149e530b0f3f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8e7f19bcb29f6effa3d1f5454180ce1bd8822d54a856ec19b9f910327ba0baf"
    sha256 cellar: :any_skip_relocation, ventura:       "41022566fcfe8f0f4f08f6c34b2312402a88c98286c93acaaca5f18d69ab5072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be8f7516b891ef2d1b59c48ee9f78a441be392ef464d65caff2ded2a50042963"
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
