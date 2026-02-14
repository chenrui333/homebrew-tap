class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-1.3.1.tgz"
  sha256 "6b029745275d87088fe5a127725b0536193a678c54d692308718d4d985fb0286"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "388fa1db7fef6378026648590e63dbe3457e16e4553eb7abf2f79db3007bef0e"
    sha256 cellar: :any,                 arm64_sequoia: "0935c13c6438af36ad6063c3c7379b29aa0d30f7551080d89d64d45c3eb77b42"
    sha256 cellar: :any,                 arm64_sonoma:  "0935c13c6438af36ad6063c3c7379b29aa0d30f7551080d89d64d45c3eb77b42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39bb091c3a2ae6d62280ba4851af83f1bbc0f83e12a76b590ea398af2985ee67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "412e9cf9a59a66b4c1530ee599b041817ab3f90c46758db060472445343a9b52"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
