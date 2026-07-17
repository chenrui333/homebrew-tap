class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.11.6.tgz"
  sha256 "1babf745bdc309cc3e5d4221084fc66a1e913d4eae05b79f539654197ea6790b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "8b2ce8ac6da7ed0dc277579699659bfb709d997290f2e8d3bf5c3510b2a31203"
  end

  depends_on "node"

  def install
    package_json = JSON.parse((buildpath/"package.json").read)
    package_json.delete("devEngines")
    (buildpath/"package.json").atomic_write(JSON.pretty_generate(package_json))

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["APIFY_TOKEN"] = "test_token"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew-test","version":"1.0.0"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized"}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    output = pipe_output(bin/"actors-mcp-server", json, 0)
    assert_match "Get detailed information about an Actor by its ID or full name", output
  end
end
