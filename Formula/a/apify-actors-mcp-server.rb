class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.4.tgz"
  sha256 "54dc761b8cb5164218b5e2446d54dc5676ff16418629424162570d8f9058350f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9231673f3bc5382db368cf6a150ce7b30b179d4cdc0b406ac3820780bed7ec78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9735af78f16034c5fc2a445513993e3dad9d38d5c8a97afd02c51ab83239dd69"
    sha256 cellar: :any_skip_relocation, ventura:       "cffbf1b7df07e142a0062bc6dd9a89e6f9bc82fc32dc838fbbbe76104301d277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bde53a69a643e390f67ca62073a130465a3b14fbaddbc3d408754bbb65aedc10"
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
