class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-1.0.0.tgz"
  sha256 "a80f0afdb46f1448a0e338dafb267d35208a08553338626a599d94ad06f399b9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_sequoia: "0a74d8fe5b4ba526e2c8ef8be5bdee7f410a8a8450fb6ef666ee6b1f3be9dcf3"
    sha256                               arm64_sonoma:  "35603e7d271d3994548a09da1646dab7b88a11936e662a83aa2841236eae94d5"
    sha256                               ventura:       "6f4f2a345f76a82026382da45a0b4cabd7a218cf97b2732e89e583daa752d65f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cfa19f2ec11545eda518f53795e9e9808f03dad77ef6899f056cd10bf59e164"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mongodb-mcp-server --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    ENV["MDB_MCP_CONNECTION_STRING"] = "mongodb://localhost:27017/myDatabase"
    ENV["MDB_MCP_READ_ONLY"] = "true"

    output = pipe_output("#{bin}/mongodb-mcp-server 2>&1", json, 1)
    assert_match "Failed to connect to MongoDB instance using the connection string", output
    assert_match "List all collections for a given database", output
  end
end
