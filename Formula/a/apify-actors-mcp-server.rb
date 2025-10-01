class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.21.tgz"
  sha256 "ddc59c981d398edbd042d75554a2fd90349a0a14d150a22413d250da161d6924"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbc6d67fe3f023c2b4f18a84192d11b48cd4abc46a5f3d39e277001d67b70ee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3499a46809a3718f43f2c780e4276db785154344ea9dd9174a47aad80fbb626a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67abe5d3eb22e3b8bc771d51939563c7ffff27e8a16affd93b189f4998103766"
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
