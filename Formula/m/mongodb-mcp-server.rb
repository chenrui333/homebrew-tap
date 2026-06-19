class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-1.13.0.tgz"
  sha256 "686cbb014bc60cf322e2285b91c0f990343f0b10b17b56328de6f405e581e223"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "792f41d7919f6538f639adcfd93d306bfaddebcbcb27cd9117d3ab3cd885f82d"
    sha256                               arm64_sequoia: "0a22d8190ae1a8daef75560a2c83cfbcfad7875c10df121c35cb1c170435f02f"
    sha256                               arm64_sonoma:  "0a22d8190ae1a8daef75560a2c83cfbcfad7875c10df121c35cb1c170435f02f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e72eea6592e68870482e0d70c0e9989cef35e6d34a116b5b45539e01f8bef35d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35b30fd635c93fdfc84b2dedcb91bdfd84e2efa6a9a1ba1435499fccc0a2fa89"
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
