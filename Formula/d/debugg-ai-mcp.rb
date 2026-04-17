# spellchecker:off
class DebuggAiMcp < Formula
  desc "MCP Server for Debugg AI"
  homepage "https://debugg.ai/"
  url "https://registry.npmjs.org/@debugg-ai/debugg-ai-mcp/-/debugg-ai-mcp-1.0.49.tgz"
  sha256 "0c047e489c256c8156980a8f3053ed0089b2026be015735fec1d195a403a7e49"
  license "Apache-2.0" # license fix PR, https://github.com/debugg-ai/debugg-ai-mcp/pull/4

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ffe9a353fe5bafef9eb4b945a9590f755d35783fa88fe0f31615d9ec2a1e7063"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    # Remove vendored prebuilt ngrok binary to avoid shipping non-native artifacts.
    ngrok_bin = libexec/"lib/node_modules/@debugg-ai/debugg-ai-mcp/node_modules/ngrok/bin/ngrok"
    rm ngrok_bin

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["DEBUGGAI_API_KEY"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"1.0"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/debugg-ai-mcp 2>&1", json, 0)
    assert_match "\"name\":\"check_app_in_browser\"", output
    assert_match "\"title\":\"Run E2E Browser Test\"", output
  end
end
# spellchecker:on
