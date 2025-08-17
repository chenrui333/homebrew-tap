class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.34.tgz"
  sha256 "bb2a7c20231c197903585dab586cfa0b78b78bc4cc0bf9c8c279d7b46875a919"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a9813916947b786f2cde665fdc8c57df52500fda25c9bffc3f868f0c576299d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "655aa6b4dd1d6f00f0bc7da673035417fa2f8afd4754ef154601d679f39b36ad"
    sha256 cellar: :any_skip_relocation, ventura:       "915dacdc6c13fbc8bb2bbeda07bf01b93bb935f635e916bab19635a332aef248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97059147784b849c52a7d888916383c2c00843c072b991ed9748ccb06a439647"
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
