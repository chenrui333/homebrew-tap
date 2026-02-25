class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-1.7.0.tgz"
  sha256 "0e2e2f0f38f3404eec2b884a83a4edb3517329539873e58287979e739963c029"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "31ce8feafa886dd7b47adbee3315e359c0fbda2db88309df39b980d174e565ab"
    sha256                               arm64_sequoia: "03cd8ae7aa361d560038a20869a1595c540e1cea57b82d8bce0406d109793ccc"
    sha256                               arm64_sonoma:  "03cd8ae7aa361d560038a20869a1595c540e1cea57b82d8bce0406d109793ccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b40a48d1209ff3b4ce3a984b337d743c704615783eefd4755712d9dca40fc33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94b73404d2010321a5592f956b7f4644ef23354f68ae93df8a9e1c69fa6a5e8b"
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
