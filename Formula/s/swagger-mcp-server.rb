class SwaggerMcpServer < Formula
  desc "MCP server for Swagger/OpenAPI endpoints"
  homepage "https://github.com/gulbaki/swagger-mcp-server"
  url "https://registry.npmjs.org/swagger-mcp-server/-/swagger-mcp-server-1.0.1.tgz"
  sha256 "c5f8f3b8288a9823fc26c3d3a8a4806ea48f3260b9da9e7c705a902064cf4265"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aef87fc6e1ed0fc7fe6a32f8fe0e562320456a6532a9ba6998e6914829f10f0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "148427d58b704a93315d3ef01fd37068e558b66cde7855f77e7959c1ecc210be"
    sha256 cellar: :any_skip_relocation, ventura:       "7930cd1672b72c3cd977a2b75c8424d8fcd918664b2c48559c9c8980cbe7c67d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5d2cc0f92c78bcfe32fef19f2765134e6bbc3230b338f2865de70b7c86d2a35"
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

    assert_match "No config file provided", pipe_output("#{bin}/swagger-mcp-server 2>&1", json, 1)
  end
end
