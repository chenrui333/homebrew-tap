class AppleHealthMcpServer < Formula
  desc "MCP server for Apple Health"
  homepage "https://github.com/neiltron/apple-health-mcp"
  url "https://registry.npmjs.org/@neiltron/apple-health-mcp/-/apple-health-mcp-1.0.1.tgz"
  sha256 "998cfedb34d1e3240f0408459e91e01fef5b28953b71889d6159772e0b385c30"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_sequoia: "73872c239da5fc240d093d97af82f4b0708248bfa118a09dc87d616026575737"
    sha256                               arm64_sonoma:  "a31c58b5bd3132897f2e450d4041161971b572cf12a31aae6861566cac9ae665"
    sha256                               ventura:       "07a0d12a4b262847a2971dbe6baeb1ffd8b36f0c76d76bd510541b091102e856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fe7b2f4808283dfdbbca9e1cbbc0711e57511d710d07affe16d997009e93bf0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/apple-health-mcp" => "apple-health-mcp-server"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/apple-health-mcp-server 2>&1", json, 1)
    assert_empty output
  end
end
