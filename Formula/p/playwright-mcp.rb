class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.39.tgz"
  sha256 "4539fe6747f209562ea36cd6fb1b1675945295d77fa48fa4f0ac1a8cbf2be244"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4408afb89019eeb33b7b71a537ea1b499f103fa713ed0b9bfef3b8ef312e0ea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c91d25fb99101ae2832722b905e043eba327005d91d10c414b26d10f512a7fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be90e604f83b2dbb7450cf949853528e99a61b9317f0def4c10a9dcb06a64eb9"
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
