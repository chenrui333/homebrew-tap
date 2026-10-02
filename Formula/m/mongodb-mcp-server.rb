class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-3.0.5.tgz"
  sha256 "c04dca5e910fb8b52b8565a9f47d6b11ea03537cbbf302d48e0803c0325bc58e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "705c43dd942aed8966a4ce6cbd17aaf6bbb9a8b3e2577b469e4e11857940f017"
    sha256                               arm64_sequoia: "705c43dd942aed8966a4ce6cbd17aaf6bbb9a8b3e2577b469e4e11857940f017"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f571cdfa2e83515a0817db68f61cfe3ac57076c3f15f927ebab11b8491216442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "956d651a100e483472292366aa084d66fff5210688716db8fd1653763993dd01"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
