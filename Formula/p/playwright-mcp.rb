class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.35.tgz"
  sha256 "8c7bc489ce0ff2004552cd6dc20c4511d9a56e6d9bdcdcd63a816a4299640817"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "445a0d3ef197e70b1ffa00b3c3b84780113d77a6b53dae6e53b665fddb96e5eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "004e186f36878eb5c776d59b968a3faa72afe889018f80e333611c7e4e6579b7"
    sha256 cellar: :any_skip_relocation, ventura:       "0b3ce585db7b98529a7e0fe3781de938301211010b942bd893f6ddd1cdae22bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94a72b60e11f1bbc2b71f88dc2bfc54d8eb6b4c8a08406ec02a079ccb4ed6ff5"
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
