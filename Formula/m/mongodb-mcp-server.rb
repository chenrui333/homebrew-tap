class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-1.14.0.tgz"
  sha256 "db022e339db6156547550a13fead0829493b00161928d8d43e7ae9bb9edc7e96"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "f6f874dab90ddb149a5e612875f9da9ed6cbae69fd93b8d61323a212f0772ee4"
    sha256                               arm64_sequoia: "f6f874dab90ddb149a5e612875f9da9ed6cbae69fd93b8d61323a212f0772ee4"
    sha256                               arm64_sonoma:  "f6f874dab90ddb149a5e612875f9da9ed6cbae69fd93b8d61323a212f0772ee4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9e0896c7a98a8173b774834811b628f874e979d6d0ece3218b29678f2d33f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "498bde1e38cbe8d61a108c57a3e8dbd4d870d0b3641d06044fd91b4b782e3151"
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
