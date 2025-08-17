class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.34.tgz"
  sha256 "bb2a7c20231c197903585dab586cfa0b78b78bc4cc0bf9c8c279d7b46875a919"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "723e75da1f15e851607fbd81bcdfd03fe1cfb0f34837fb7f703c5d91bc48a47e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "980e06022ad1afc8d1dd299986fedef8d177ad6eefd86c3c7599f2825200f842"
    sha256 cellar: :any_skip_relocation, ventura:       "a3a1bf65e2dca776deb3294a1eaa65c538d42cd4ece4d66ed97c5cb26c0bd699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aac589e2c0a6b51eb803f51bb40df142ba4ddf6cc2b01021005a623b63d53b0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-server-playwright --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    assert_match "browser_close", pipe_output(bin/"mcp-server-playwright", json, 0)
  end
end
