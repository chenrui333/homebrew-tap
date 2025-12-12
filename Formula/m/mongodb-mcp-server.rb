class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-1.3.1.tgz"
  sha256 "6b029745275d87088fe5a127725b0536193a678c54d692308718d4d985fb0286"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "100ce384c52284551bb3719acac2e62e712fcbbcba7403390622308c5207d77f"
    sha256 cellar: :any,                 arm64_sequoia: "20257b9df8000b14cfddde81c6620f6df7bdf0bda3643a756ab82c6a46a7c0d3"
    sha256 cellar: :any,                 arm64_sonoma:  "20257b9df8000b14cfddde81c6620f6df7bdf0bda3643a756ab82c6a46a7c0d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d6d04aacf8362fb1e6f8d2b4df52a172991d05d8014f70d75f1f8b78f2aa577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d980f18db7fdc5848d541bbefa98a54dd93865dc9071fc230831ca617db0ee4"
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
