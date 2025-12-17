class McpRemote < Formula
  desc "Bridge stdio-only MCP clients to remote servers with auth"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.1.37.tgz"
  sha256 "d9d55af8b04926ff3223f0876b4a50c2dc04d13e490f1efe31e60c7e7b29b0cb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "a7e42c929689d09902affd82b47af3ab818861b118493ac6725f2a043bffa53d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/mcp-remote https://example.com/v1/sse/stream 2>&1", 1)
    assert_match "Connection error: Error: Error POSTing to endpoint", output
  end
end
