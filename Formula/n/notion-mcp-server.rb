class NotionMcpServer < Formula
  desc "MCP Server for Notion"
  homepage "https://github.com/makenotion/notion-mcp-server"
  url "https://registry.npmjs.org/@notionhq/notion-mcp-server/-/notion-mcp-server-1.8.1.tgz"
  sha256 "34cf7128d29d0d2dcbf412eeafacf164120a3232c630dd14c137ffb5b923b229"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d900d9708df30211efb480a14cca8d4da284d15565f2d9254835c32c5cdb6bc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63bceb19c435774bdedc02d243f47ddbd202d337184b0863edcf8cffcd875c9a"
    sha256 cellar: :any_skip_relocation, ventura:       "98ac3e7661ee7d284628f1d68c5467202de8ae38e17b7fc5ab80bba6e2bebaaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a145afae10509c11f534d0186f1ad8f39738bb156336f157f0bc8a79e061cffd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Identifier for a Notion database", pipe_output(bin/"notion-mcp-server", json, 0)
  end
end
