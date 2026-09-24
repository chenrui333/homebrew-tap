class McpRemote < Formula
  desc "Bridge stdio-only MCP clients to remote servers with auth"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.14.3.tgz"
  sha256 "f4ab0e33b38b24fff6a8b3234f9d683e47995ca44f3186481716d444836f7254"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "8a7e9a72f7be16025acfbf410b8fd1731c69eb4c1e416a8fb861066ad7dd25e8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-remote --version")

    output = shell_output("#{bin}/mcp-remote 2>&1", 1)
    assert_match "Usage: mcp-remote", output
  end
end
