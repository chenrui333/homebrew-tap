class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.37.tgz"
  sha256 "221c6d702d1d01652cb0f8a598576679ff39e294a64afb04a39a1494e63750d4"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1418986cc8a3086eb92e694335868b4217b216cea05a045ca48f12fb3e35570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "befdd96bd4c30e548ef6895f6ede00231d4eb4f14f0243991b58a5889b0d28fc"
    sha256 cellar: :any_skip_relocation, ventura:       "6bf5d032a6e2e4e1de132ec9354d20bda8eea67bdaf2f47768cf1ea690b1df9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3453798b2923030973d6b272710a14bb4ab2245aca3b582118a0516367539cc6"
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
