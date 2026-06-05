class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-1.12.0.tgz"
  sha256 "b86eefc17d9c0fd8e6d2b253ad2aedc47abec65453e5e526c976aa0ffd01da11"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "af7fe43f50247cc11562d104af8c3ef02fe25a0bd667921ca604574de4bfb37b"
    sha256                               arm64_sequoia: "316c50455a1db7ef8d0d59e5e1e8543431a454c52b828b4ea5e76e2e9a094919"
    sha256                               arm64_sonoma:  "316c50455a1db7ef8d0d59e5e1e8543431a454c52b828b4ea5e76e2e9a094919"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "906035db5878308adaab1d9c4065c5f54dbfd66b7b2bcb69ef414fcf3a1f05a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c26644c761d08069b4867e752237ac972463737bd1d2ce529cff299359660064"
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
