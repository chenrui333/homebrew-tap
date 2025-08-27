class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.1.tgz"
  sha256 "8ea0418d12cef820ad1a92eb5e34c70eafb550705e4e8707909b02de316a0a59"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "022845204091610405255be897c0ee8a954ceca651d3db05373a128d7aa79488"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca5e3c357e57440c746da3770233775aed18fe9bb1ae685a7262915ee045ffbc"
    sha256 cellar: :any_skip_relocation, ventura:       "07b41ee4e3a9707f0623fdbfcf8ae25f2e6ed438eff271a9fd12479417da35a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfb05d4d86c2c4aa525b8ea7948b99ffb777ebc086c87dd3d2e0f0eeee91d0a0"
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
