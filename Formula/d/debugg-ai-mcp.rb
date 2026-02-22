# spellchecker:off
class DebuggAiMcp < Formula
  desc "MCP Server for Debugg AI"
  homepage "https://debugg.ai/"
  url "https://registry.npmjs.org/@debugg-ai/debugg-ai-mcp/-/debugg-ai-mcp-1.0.26.tgz"
  sha256 "92f5c2f4d1d2a12291e5dd9fd9d7188e1bd6df471e21638256b41db9d671319c"
  license "Apache-2.0" # license fix PR, https://github.com/debugg-ai/debugg-ai-mcp/pull/4

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66488e6768c8a75fb8e5f5fef1d1b94bd50bf42a7281481102ce4f63b574acd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c49e49cbd3dd01035a51983b2132ecf9fe9c199c47d2792b60bcb684d592d30c"
    sha256 cellar: :any_skip_relocation, ventura:       "9aca20da0cc9e39966664e32a5b95bcc63f249b4efac939036109d3db2c55e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b339ec10d9856b524929effd22f9fc11ba99c1996e41a1bcedc92413d4e70e04"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["DEBUGGAI_API_KEY"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/debugg-ai-mcp 2>&1", json, 0)
    assert_match "Run end-to-end browser tests using AI agents", output
  end
end
# spellchecker:on
