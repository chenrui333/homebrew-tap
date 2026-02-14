class TwilioMcpServer < Formula
  desc "MCP server for Twilio"
  homepage "https://twilioalpha.com/mcp"
  url "https://registry.npmjs.org/@twilio-alpha/mcp/-/mcp-0.7.0.tgz"
  sha256 "7ff791d1023cad6372496d8aba1c49bc3ffbcf0989b9f96b3a83d2df9d6af755"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93cf6ff5f954d129a441da08bb3bb879eec7cc48bfdf96248602c0dea42b1c70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47426b4c8447bf2f416536043c2aa0064cd4ebce93d0944b1f81b92feba0082b"
    sha256 cellar: :any_skip_relocation, ventura:       "fa7499032bc70b7c64165f0039c62528cfd7e4e6c4a838bbd6624a699c1309bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d748a97429a450d0d6ed39e3f434790327e57ee4694d7487cebc81c272685ae"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
