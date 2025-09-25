class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.40.tgz"
  sha256 "c906bc8b1fe534196c3d6d022e81ed045113993edc3db6d0c3f4450adf269523"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ff56878fa886306d7ff4245153d51cd382e366b107710f4c99397609643d8e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24f1051340127676145f8871a64dace0939bda844d4aaae4a2d2205c990f26d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03e230349633a744d28abdaaf49a8405af3015031ab34dce555df40b948f3590"
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
