class MongodbMcpServer < Formula
  desc "Self-testing CLI documentation tool that generates interactive demos"
  homepage "https://deepguide.ai/"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-0.2.0.tgz"
  sha256 "6821ad58c5c9f07f878a0fb8bfdbe4e34c8a867386981973e1c67a44a2924a28"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/mongodb-mcp-server", json, 0)
    assert_match "List all databases for a MongoDB connection", output
  end
end
