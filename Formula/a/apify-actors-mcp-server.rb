class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.10.tgz"
  sha256 "f40c0c3779d0fde30614d21c8c1d98360a017de800c7367187524a84a9d713f7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f142c8fbb0d2e3db64e84a155678de9491ec853218ac694250766700b1e60ad8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a6708c522ae41e500b0da21e999287aa7b87b2738de216886a840aac14ee16f"
    sha256 cellar: :any_skip_relocation, ventura:       "a5b29ddc3d794ecbdc9d6462b85aceab48515daddd4a7e50feb4ffcf9bd510df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4f971cb18b743b10b5429783d130d52775c5341b9375d174b5e061535741df9"
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
