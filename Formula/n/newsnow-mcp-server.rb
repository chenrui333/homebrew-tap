class NewsnowMcpServer < Formula
  desc "MCP server for NewsNow"
  homepage "https://github.com/ourongxing/newsnow-mcp-server"
  url "https://registry.npmjs.org/newsnow-mcp-server/-/newsnow-mcp-server-0.0.11.tgz"
  sha256 "c0d6d7baf25f4450d1faf135ef925fe8d743b3976d382ae46644651e4a5046aa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d290d5d7915f533d60b903650069a9a6d96d5ec0d687f335fd3fc1df364df31e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd199f52c62fe2b4a5896e538c0cc783f0a02215240b10d234ccba8e1b8a2c26"
    sha256 cellar: :any_skip_relocation, ventura:       "d93e8ad5abe05e03faed15b6caa049b1b01b30a1119fcfe4dde83eb8073d3d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "197ca5c47a269c1f5b4c46fbd0ccab7081b3c10aa796a073ec2d5db034ac2d9b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["BASE_URL"] = "https://newsnow.busiyi.world"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/newsnow-mcp-server 2>&1", json, 1)
    assert_match "Server does not support completions", output
  end
end
