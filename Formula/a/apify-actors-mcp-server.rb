class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.3.7.tgz"
  sha256 "7550642c7a850b6ba5f241160508d9ad32a6cf3730b81595413480603beda9be"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "983827769e757ab30691a18ca4ab0ea6be2e2e0083c33224c86640e4bad575d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "348fd882859e10a63351c3f3537fe3d11a2b4895bddc1337a56dcbbd1478d7bb"
    sha256 cellar: :any_skip_relocation, ventura:       "1b1ac50035df7ae007cc5e69363613dae397638afc16dc43cc18b819a7097616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b5696a6d73b3a00375b0b7588b4b436f6e6731ca6b53e1a15fe66bacf0b38ec"
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
