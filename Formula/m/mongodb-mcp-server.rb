class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-3.3.0.tgz"
  sha256 "94b742d900b4b0c264e83ee802abfc008690b4fc4c01883950f2424ee50be043"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "d1359a3ca9a2dc986bfcc3ac46eab547d6f0f12db50e17b557d4d166487c5348"
    sha256                               arm64_sequoia: "d1359a3ca9a2dc986bfcc3ac46eab547d6f0f12db50e17b557d4d166487c5348"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e273669ccde1745d97c6fd647744b6e0f76ab7c75e9057d3d2403bb555838120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e73a263b963286d477c2d34ce3bfc8a284999461dc81f322aeca250fd23b4a7d"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    if OS.linux?
      # ext-apps vendors Bun platform packages; keep glibc builds but remove
      # musl variants to satisfy linkage checks on Homebrew Linux runners.
      libexec.glob("lib/node_modules/**/@oven/bun-linux-*-musl*").each(&:rmtree)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mongodb-mcp-server --version")

    output = shell_output("#{bin}/mongodb-mcp-server --httpPort 65536 2>&1", 1)
    assert_match "Invalid httpPort: must be at most 65535", output
  end
end
