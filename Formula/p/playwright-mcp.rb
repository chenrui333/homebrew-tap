class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.39.tgz"
  sha256 "4539fe6747f209562ea36cd6fb1b1675945295d77fa48fa4f0ac1a8cbf2be244"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a659d9040c2c37263129327eb61a8048fb91ecab9424bdd8f299b4964c90413"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c423b8475c918ea6326ea9db53c196135d78b8c161dbf4d214a3f14705428362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45e462dcb8e5be09ed6d99d52d3c462ee58ba6383c864500bc4ed2af8e919698"
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
