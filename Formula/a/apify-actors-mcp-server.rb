class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.16.tgz"
  sha256 "f92c1f736dd8b6d6636260c46f0265d00c85dc118784f8cbb6b2f736bfa64ac3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a0df1197440ac83e891641283efa9fecef6c0aa7ac05c0e26f11221c34e6006"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb71e845f78b24c4ee55623de2dd64a10b905a370f4803087abc235ec8694251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06262b5a739e964e34cdfe363e386ec4cad893bc6515b7216b2da43e6c4ecaa8"
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
