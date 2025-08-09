class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.33.tgz"
  sha256 "6ea12cf81765848c02bb2b70553a4f4e9dfe81cd4a9d04160b0603e38c1ac26f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32de2948ed8e31d577a7c20a80e1d70012d514e2a785481eb9119045848daec1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7340527bfed2f0422cdc6f489309cfe1c677163e8e1f0238116032eb4d05ed12"
    sha256 cellar: :any_skip_relocation, ventura:       "19329448d84c3c0ffc9addd9893d91ba912cf7fdc1b98e51d902826ee5578a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26dcbc55fedcab5cc97a8cb2aa4a94da681690c067a18d5bd9ab1b46bda81f64"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-server-playwright --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "browser_close", pipe_output(bin/"mcp-server-playwright", json, 0)
  end
end
