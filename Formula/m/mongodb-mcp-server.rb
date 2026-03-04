class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-1.8.0.tgz"
  sha256 "94841bc620a93c00f7f7b8d86d5217c44f68cc8dfe3a909cbbfb055bdf271c18"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "531ad9ad4971212cd8afd5fde1b75a515d60d9799ce0830b71c9ae4db1559705"
    sha256                               arm64_sequoia: "340ed840c830705723fbfb92be3d52456777db535a1649748b2b116590c8ea26"
    sha256                               arm64_sonoma:  "340ed840c830705723fbfb92be3d52456777db535a1649748b2b116590c8ea26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5de4e9629da3603fa9bbb3f236266c97f2175bdbdd7c93bd76c4a4d7d0bfac36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "105fa600f2e04f77bc8433a15e2674c7199ae8a35fe7724b8b20609780054a95"
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
