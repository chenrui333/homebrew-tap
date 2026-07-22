class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.11.7.tgz"
  sha256 "be5f6b4b30087496c2e60e601ca84a5a8d66b9156094300990ca63d4dc6d5b69"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ee63a82607f9edb1df93a972a30237b7a9a800ba6d4b5317dc03a359e061b44e"
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
