class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.3.9.tgz"
  sha256 "c1f6cbee80e8bdef4e5f2491335d486b7a87a894a9952587d8ccf659c4a86e9f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b739cd996adc9aef07c412048a55e2d566fece2498d2cc166b4184355b9eaa52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "647281a1493f7c996b75741ec4e361cc4dc13c54e6ac92f9fb3d5e8c1d89f1af"
    sha256 cellar: :any_skip_relocation, ventura:       "89d167fe7aa57d6e35179d8146cfbc1461609ee88821b70a55bbe8ba09394233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a64196f6f63a6a1af67a86be127bf2bc7db833f166320833a0b0dbcb8440ff55"
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
