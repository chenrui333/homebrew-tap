class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-1.9.0.tgz"
  sha256 "d9aa4614e217f61b447d53cbddad072a45596975a910e3d92b6ef7889004070b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "13c30b80ad7c9f356fb8cce34130a45ca4151603b579b8a6d65e30924856be06"
    sha256                               arm64_sequoia: "45162f8daa666e3523c2dc4388ee22ef53daa6f6125dedf126f88048c0f34324"
    sha256                               arm64_sonoma:  "45162f8daa666e3523c2dc4388ee22ef53daa6f6125dedf126f88048c0f34324"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c45104aeea2b3363f8988ff34687cf604e8407a322b2ed7da6193c54c10416c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6d1419662b14fcc83dfcd79d8e785323f95ba08af5a8558af9270fe80461620"
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
