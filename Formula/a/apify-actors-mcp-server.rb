class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.21.4.tgz"
  sha256 "1151cfcb34ead6ef40044d3c4d0cb49841da0cbf0afbda7d77cb214c651ce2e3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c6a2f9657fed25c1577f5dd74cf7e8c9e788ae03ac86cde9f11d573d86a714d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c6a2f9657fed25c1577f5dd74cf7e8c9e788ae03ac86cde9f11d573d86a714d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8a2a7ec815e7f493eccdd6937a856c5125575ee67f238a35e3edfd3de97a9ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8a2a7ec815e7f493eccdd6937a856c5125575ee67f238a35e3edfd3de97a9ef"
  end

  depends_on "node"

  deny_network_access!

  def prepare_package_json
    package_json = JSON.parse((buildpath/"package.json").read)
    package_json.delete("devEngines")
    package_json.delete("devDependencies")
    (buildpath/"package.json").atomic_write(JSON.pretty_generate(package_json))
  end

  def fetch
    prepare_package_json
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    prepare_package_json
    system "npm", "install", "--offline", *std_npm_args
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
