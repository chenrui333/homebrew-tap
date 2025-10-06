class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-1.0.2.tgz"
  sha256 "3186706e4196d721048ad66e8d0f16fe9d8a99a9e15c3232304e253865bb78fb"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "ffc6287c4ab11846e69a9696c0685a309840e21dfc7fccc6a8c1adf004faca99"
    sha256                               arm64_sequoia: "74aa066976bd73d849cce0bae79c07952db9b6c0f9f98b46aeba0babe6af19ef"
    sha256                               arm64_sonoma:  "8e6bca1a76323248f71092d45d55c1a5bd13db0fd2670ae8ea6826cf28041752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecfc6823a82f24bc368f9e512bc23ad55d37f7ca6db51edc178197498f894b33"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mongodb-mcp-server --version")

    # TODO: re-enable the json-rpc test
    # json = <<~JSON
    #   {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
    #   {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
    #   {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    # JSON

    # ENV["MDB_MCP_CONNECTION_STRING"] = "mongodb://localhost:27017/myDatabase"
    # ENV["MDB_MCP_READ_ONLY"] = "true"

    # output = pipe_output("#{bin}/mongodb-mcp-server 2>&1", json, 1)
    # assert_match "Failed to connect to MongoDB instance using the connection string", output
    # assert_match "List all collections for a given database", output
  end
end
