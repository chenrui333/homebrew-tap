# spellchecker:off
class DebuggAiMcp < Formula
  desc "MCP Server for Debugg AI"
  homepage "https://debugg.ai/"
  url "https://registry.npmjs.org/@debugg-ai/debugg-ai-mcp/-/debugg-ai-mcp-6.1.6.tgz"
  sha256 "c824940bc440aa6763544a7b839809909f282d8fd44149d7cf519808ce2dc601"
  license "Apache-2.0" # license fix PR, https://github.com/debugg-ai/debugg-ai-mcp/pull/4

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86de664f1f959abba3ff95236804085811e6d44cca2011d3e03a9b63ebed57d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86de664f1f959abba3ff95236804085811e6d44cca2011d3e03a9b63ebed57d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd16910c58806cfc887c056cf4c06846e848aa52e068dc256a58c70be6934016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd16910c58806cfc887c056cf4c06846e848aa52e068dc256a58c70be6934016"
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
