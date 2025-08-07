class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.3.7.tgz"
  sha256 "7550642c7a850b6ba5f241160508d9ad32a6cf3730b81595413480603beda9be"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3ab5d8c3892dfb3066e884f1a83fa7f1dc619928c8332d4d1964f39f1063d48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35513092b141ae52180aa1f697e6a9a1135fa320a85ad967c033bd15c287dc62"
    sha256 cellar: :any_skip_relocation, ventura:       "dc059910838c500cd1921574ec161d88a80af41114872d148846ff9174fe4ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f63acf4cf0262d8e75af89159b33bcfc4d9e197d113fab6d1832b583c5c1a691"
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
