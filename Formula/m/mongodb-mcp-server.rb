class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-1.12.0.tgz"
  sha256 "b86eefc17d9c0fd8e6d2b253ad2aedc47abec65453e5e526c976aa0ffd01da11"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "d27b71333c2e96a033925aa54f3cb42f708498906df07d74ccb7d716f7bd5837"
    sha256                               arm64_sequoia: "17c5931157e4f6cee011f7d96f884b866620b082db435bbd40aa1e885b0d57b5"
    sha256                               arm64_sonoma:  "17c5931157e4f6cee011f7d96f884b866620b082db435bbd40aa1e885b0d57b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97478977f12ced5a0eeff2fa933f567559fa90a3147df3f3c791148f4764d46a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "429d5e8d16bf5d834b8d935f1c53e0cee47f3a736b7186a4db4d05a7abae5f29"
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
