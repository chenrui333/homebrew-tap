class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-1.10.0.tgz"
  sha256 "3e9e5701117352c579329332a659bbd7776d12f4ce0d068551c6c9600a517924"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "a81bbb126dc249c2bef3cb5638a24a28e9c0e7f5780eaaf745bc6ed6c49de8e8"
    sha256                               arm64_sequoia: "53d69398c1c79bdc06991ca20459bbb7511b53c4462dbd5b30bd69234f21fa45"
    sha256                               arm64_sonoma:  "53d69398c1c79bdc06991ca20459bbb7511b53c4462dbd5b30bd69234f21fa45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c78709bb72524ebfd7dbc53bc5067475dd04f5c36fa6c1bf9bdc21104dbb1fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afd9e6d16db4edf0434b54afb9db7b7a3441acc3b0031e172567b8fb909d304d"
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
