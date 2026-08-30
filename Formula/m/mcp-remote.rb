class McpRemote < Formula
  desc "Bridge stdio-only MCP clients to remote servers with auth"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.8.2.tgz"
  sha256 "3ebcee6ebd7fba095730123467be49d77726801e81e26dae1395901a7ed828d5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "aac9967a0137cbaf7a144ed3f0dc42cc9bc11127c2f4c20c9ff9a54129d6627c"
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
