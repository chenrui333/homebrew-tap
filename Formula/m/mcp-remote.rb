class McpRemote < Formula
  desc "Bridge stdio-only MCP clients to remote servers with auth"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.15.0.tgz"
  sha256 "17b1af212c06c964f92220ecb45f6fd73abd3f818471d2a518f96870f43ff2f2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7c9e90673cfadbb71fae8d6820b50d73574b54e8928737e8ff55cd733f455a85"
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
