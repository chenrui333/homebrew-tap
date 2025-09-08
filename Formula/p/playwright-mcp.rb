class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.37.tgz"
  sha256 "221c6d702d1d01652cb0f8a598576679ff39e294a64afb04a39a1494e63750d4"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11b36cbaa8a0d10e64ab5814fdd7fb94968f93c5f050ce8f7877d0d20a2c63a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74801c7e92a1c509b204702eb102ce1cc5bf73732080c09497d9b46946debb68"
    sha256 cellar: :any_skip_relocation, ventura:       "35198823530465c5cfc9dd87d211097a8e4eb802b4439c0f976a9eb71d115e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d08968ccb22da075c37c140dd78b618f09c343921338e4e82a637e3200189ac7"
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
