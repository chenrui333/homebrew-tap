class GraphlitMcpServer < Formula
  desc "Cloudflare MCP Server"
  homepage "https://www.graphlit.com/"
  url "https://registry.npmjs.org/graphlit-mcp-server/-/graphlit-mcp-server-1.0.20251112001.tgz"
  sha256 "7682925f3c471c599e98ff51ec604006ab8a4f3379a22e4796b984c4978cdb02"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3eaff2c5067257e7f0421b2d7ea54b9c1a60595b6d95ac929ed02151a49bcd13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef9c39d6013e0ea75a411251efaf1149c720e9a807b36402e09d1575124e0786"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b88af779c59381102146fd7ed701a5a281d999aa93495e4abb7699a17f0c6b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b94d94d688d7dbf86417dfc0cc7a5d8dac9a16c82090daf7b4de20abf0ed937"
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

    output = pipe_output(bin/"graphlit-mcp-server", json, 0)
    assert_match "Prompts an LLM conversation about your entire Graphlit knowledge base", output
  end
end
