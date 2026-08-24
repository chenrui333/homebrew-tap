class McpRemote < Formula
  desc "Bridge stdio-only MCP clients to remote servers with auth"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.1.45.tgz"
  sha256 "b29e2879ee36702223ab892c7ad683fc6cf4b0db7b8e995cdda501a775967d7e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "98591f55278f9cc2d8b5e720b9771b78afa1a32f739c7e962002b5d98e23c846"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/mcp-remote https://example.com/v1/sse/stream 2>&1", 1)
    assert_match "Streamable HTTP error: Error POSTing to endpoint", output
  end
end
