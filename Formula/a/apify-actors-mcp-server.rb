class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.7.tgz"
  sha256 "427c805905b81f43e1847fc5833da7924ab8332ae33629e21c6470de3118334a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eb68370908292e011e5f7d687220bfa6db88b39336d1f5d4d3dd59c9ddd2497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdfa2315949439b4f2c183a371358c8c9f78874d5c6ad1d501490cab7823d032"
    sha256 cellar: :any_skip_relocation, ventura:       "00004ea6baafeba23fd263152faae13a15ddd9614c70abfacb8208bc2a9a9bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48a2d3be9e73739af87adc2e67bb748792de9a30aabee2038b860af1c45e37e5"
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
