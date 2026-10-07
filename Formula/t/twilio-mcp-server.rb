class TwilioMcpServer < Formula
  desc "MCP server for Twilio"
  homepage "https://github.com/twilio-labs/mcp"
  url "https://registry.npmjs.org/@twilio-alpha/mcp/-/mcp-0.7.0.tgz"
  sha256 "7ff791d1023cad6372496d8aba1c49bc3ffbcf0989b9f96b3a83d2df9d6af755"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d4d0e0d9da02658d9ef2ae3e6006ea133dd95d4b1d33bb00530f6b64647905f1"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"twilio-mcp-server", json, 1)
    assert_match "Invalid AccountSid", output
  end
end
