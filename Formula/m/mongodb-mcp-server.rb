class MongodbMcpServer < Formula
  desc "Self-testing CLI documentation tool that generates interactive demos"
  homepage "https://deepguide.ai/"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-0.3.0.tgz"
  sha256 "73f3f0fe3db4f5ac7ea618350f86a69a22fa1feb8981e96b218bb3cf5bceede9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_sequoia: "6160c102944769ac0d0cf54c2625206d61172242c2583fb4d48145b36b2bb969"
    sha256                               arm64_sonoma:  "3562a99b6e6a30b156ab695d2b6866843af1ffc7abc3cf3d939bb5d7defd5cf2"
    sha256                               ventura:       "d783b28f414cb012543209632ef6f085158d4b71626edbdce37e6f94cc551d53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5b735316d4b0a721fbb1cfaa57ecc41610bb314522819b3c094e20f706a961d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mongodb-mcp-server --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    ENV["MDB_MCP_CONNECTION_STRING"] = "mongodb://localhost:27017/myDatabase"
    ENV["MDB_MCP_READ_ONLY"] = "true"

    output = pipe_output("#{bin}/mongodb-mcp-server 2>&1", json, 1)
    assert_match "Failed to connect to MongoDB instance using the connection string", output
    assert_match "List all collections for a given database", output
  end
end
