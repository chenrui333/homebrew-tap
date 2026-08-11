class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-2.1.0.tgz"
  sha256 "c23891af5544154735fbf91a5e8a688185b9000398c0202964e4835260152407"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "a23169228ab2e1ae95684e9d9e5afb670ee65fafa49455dfeb534d7c46c4f260"
    sha256                               arm64_sequoia: "a23169228ab2e1ae95684e9d9e5afb670ee65fafa49455dfeb534d7c46c4f260"
    sha256                               arm64_sonoma:  "a23169228ab2e1ae95684e9d9e5afb670ee65fafa49455dfeb534d7c46c4f260"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19d726b6e6963bac28aa33c6882817aa4487ab970d63c8a3beb28dc407a8cf65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5a160c19dd7ee07d047a0ccf06e35e776f9d738d987b85e5a0479d6c1aaa39f"
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
