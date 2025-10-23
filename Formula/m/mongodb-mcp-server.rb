class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-1.2.0.tgz"
  sha256 "cfb565bf8dcd903028ab314ce75b0b0399e80270c2063b5a94906dac885914f3"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "844b9614b3604ce8e2d995dc759a56465d0c1dd215d7308be8557bdb8fadd09f"
    sha256                               arm64_sequoia: "3d4760364b870ff160442d74dc73042cc5f056211772b5b20b90262aa982ae7f"
    sha256                               arm64_sonoma:  "043824e78796dfcc9d84a2b7684595bb3a64d33e8b4e0ab2206fd4317c0aadd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d3724545bb772d525e666d01d34d57a2bfe67b5b3701ca74b302cf2370c8cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fe4a6db2b91abdba0c86e11b6dce587631d4b30d7b6409575cbbdb7f776b817"
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
