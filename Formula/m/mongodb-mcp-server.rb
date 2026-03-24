class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-1.9.0.tgz"
  sha256 "d9aa4614e217f61b447d53cbddad072a45596975a910e3d92b6ef7889004070b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "465dbcce232afcb744b23d628332e1b71d8e685ce6046fc2ce73bd2c125b2770"
    sha256                               arm64_sequoia: "3cdecb1a55b4d9b8cf86049730db4c5390e28967095475bc6a599f5aed35fd97"
    sha256                               arm64_sonoma:  "3cdecb1a55b4d9b8cf86049730db4c5390e28967095475bc6a599f5aed35fd97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b12a3fc4e1286cf5c845b76d7103b24e1e262bbd1103a453b91f778a6568facc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5a3bbc26006c6cb1c513694f0386e6be4bc1d8bca2bfaa28b9f29024e1dce23"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    if OS.linux?
      # ext-apps vendors Bun platform packages; keep glibc builds but remove
      # musl variants to satisfy linkage checks on Homebrew Linux runners.
      libexec.glob("lib/node_modules/**/@oven/bun-linux-*-musl*").each(&:rmtree)
    end
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
