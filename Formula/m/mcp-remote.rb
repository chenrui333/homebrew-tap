class McpRemote < Formula
  desc "Bridge stdio-only MCP clients to remote servers with auth"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.15.2.tgz"
  sha256 "364a418993680ee0385baafe807f4f74ce72a4d6165dfe96c2d39dd08a8d74ff"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "5494a18013f369f6370b6e436270a5016cb6c0073a8c119fe2a18fc0bdbd0808"
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
