class McpRemote < Formula
  desc "Bridge stdio-only MCP clients to remote servers with auth"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.15.1.tgz"
  sha256 "45aa7ae3c2ad1b51383c1ddce67f6fd26efbbe6637669e8f4597abe37bb87c05"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "efbd4e0484f494ff70e0dbebdb34b4bbb9da3fce0096d0fe3a481083ee5100c1"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-remote --version")

    output = shell_output("#{bin}/mcp-remote 2>&1", 1)
    assert_match "Usage: mcp-remote", output
  end
end
