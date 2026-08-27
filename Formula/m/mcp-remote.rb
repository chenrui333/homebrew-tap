class McpRemote < Formula
  desc "Bridge stdio-only MCP clients to remote servers with auth"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.2.5.tgz"
  sha256 "06b6bb1997afb6dc9c60c080e25a8d1ec456e3cd76f5f725bbbd8d01f5b6997d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "53d652f106f4051d327d8de3b7aed95fcfd9848ae22546a9cd119ce1f1e9a884"
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
