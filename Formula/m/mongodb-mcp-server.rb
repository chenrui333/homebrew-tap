class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-1.2.0.tgz"
  sha256 "cfb565bf8dcd903028ab314ce75b0b0399e80270c2063b5a94906dac885914f3"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "0fe774ae83e920c54fa26b63fe1bab9d1dc6e372e87fa68c1baefe70a3082345"
    sha256                               arm64_sequoia: "70c68000f356f0aeb3a02c0d2bf8ef2ff854f55df79b761ce834a15876cd1013"
    sha256                               arm64_sonoma:  "96e2c6942ced5832b365e800152336c8dea8ecc73d5e7accc1aed476f3166804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b74a01eab14ade298395cb033c0f4ef99bb069d29bd9dc582da3cfc5729ecd3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07db80461fcd0c3d668e82afdf031d41f3f7072c530b437442160c602a63356c"
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
