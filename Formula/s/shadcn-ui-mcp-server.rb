class ShadcnUiMcpServer < Formula
  desc "MCP server for Shadcn UI v4"
  homepage "https://github.com/jpisnice/shadcn-ui-mcp-server"
  url "https://registry.npmjs.org/@jpisnice/shadcn-ui-mcp-server/-/shadcn-ui-mcp-server-1.1.0.tgz"
  sha256 "4aeb3400a746f1e37c9b5960b605adf978fee1f84cb8262ccd2aa9f4e79740e9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f4c7539944de67cde50bdec90b8ac1a5d04a6adbba37b89730a764d74f79fbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bca8452613ca08f2cbdd65081aa16e07e699c403834d60dfb8755723d7f064c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3195fb9a65b4f7c270c78e9cef07dc7b49918be4a7cc0582e401f0c39c72851f"
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

    output = pipe_output("#{bin}/shadcn-mcp 2>&1", json, 0)
    assert_match "No GitHub API key provided. Rate limited to 60 requests/hour", output
    assert_match "Get the source code for a specific shadcn/ui v4 component", output
  end
end
