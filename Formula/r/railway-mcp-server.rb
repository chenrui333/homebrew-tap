class RailwayMcpServer < Formula
  desc "MCP server for Railway"
  homepage "https://github.com/railwayapp/railway-mcp-server"
  url "https://registry.npmjs.org/@railway/mcp-server/-/mcp-server-0.1.5.tgz"
  sha256 "272eba7dcd014f80009c5fdf3858fe62386bfb3f2e334302bca89c4e33e1ce99"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5489da212883d5bd1f89a85d8eac7324d7980acaa4e1056ea854cc3f725ab6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e10edbb8c8432f245df8eada778f1e4ab3791517da80f17173c1be382b5bfb7c"
    sha256 cellar: :any_skip_relocation, ventura:       "b5e7882977973bad6ef26d290410b30d83cb002695cbcf5303048512d543f592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97896bb33e150c78a450a4b46f518132cf6f06c88c13bb40b8fb5c30277f7c5a"
  end

  depends_on "node"
  depends_on "railway"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"railway-mcp-server", json, 0)
    assert_match "Check Railway CLI Status", output
  end
end
