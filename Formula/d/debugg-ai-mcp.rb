# spellchecker:off
class DebuggAiMcp < Formula
  desc "MCP Server for Debugg AI"
  homepage "https://debugg.ai/"
  url "https://registry.npmjs.org/@debugg-ai/debugg-ai-mcp/-/debugg-ai-mcp-6.0.2.tgz"
  sha256 "f635791348d2161634937605f6e9ec0f97dd98b98347ca11e970795370e8f121"
  license "Apache-2.0" # license fix PR, https://github.com/debugg-ai/debugg-ai-mcp/pull/4

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "436946c62d1accaca81d1091d2cf363c44d0aa83b029fcd0a0b897509df1e757"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args

    # Remove vendored prebuilt ngrok binary to avoid shipping non-native artifacts.
    ngrok_bin = libexec/"lib/node_modules/@debugg-ai/debugg-ai-mcp/node_modules/ngrok/bin/ngrok"
    rm ngrok_bin if ngrok_bin.exist?

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
