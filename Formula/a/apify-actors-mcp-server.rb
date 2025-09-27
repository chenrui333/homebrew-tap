class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.19.tgz"
  sha256 "ab604cffaae99acc0f48ca3453b16b60f5c5bbf2c891aa5f7c508456fc25de72"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "492bcf9997ed8cdf026f1e714a87b9930200963629be4e4f80c2eb768cbfd008"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2e7cbf46719f6e98bb024dc9cbca86943db9061e53f2aadbbdb1ebc64de0401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67c3c0552c45bd314b1559a78a0e7e5345f5fa2279e4bf8b579308600ef52c9d"
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
