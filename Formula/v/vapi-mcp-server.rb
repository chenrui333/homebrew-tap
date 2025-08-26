class VapiMcpServer < Formula
  desc "MCP server for Vapi AI"
  homepage "https://github.com/vapiai/mcp-server"
  url "https://registry.npmjs.org/@vapi-ai/mcp-server/-/mcp-server-0.0.9.tgz"
  sha256 "878ebf343c19b735bddefef7e27c6402b6e9291fb2c1351d8a4072697082a5e1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b11cee0ef3048654ea6795a711f4cf8f633eab1f0f8c8bd55936b8730537cb60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aef60a09a7388e2a117d9c1a6dd7ca75b95991eae75fc49e3616ba64bc110f7"
    sha256 cellar: :any_skip_relocation, ventura:       "a2683cae1adbfaaa11ce56b7cae596b4694f009493e3934ef8c6593480811cc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35c596115b1c6b9dbaa690ed23c9a7fce4cab4ad30efb083a4910c308920fc13"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/mcp-server" => "vapi-mcp-server"
  end

  test do
    ENV["VAPI_TOKEN"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/vapi-mcp-server 2>&1", json, 0)
    assert_match "Lists all Vapi assistants", output
  end
end
