class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-3.0.4.tgz"
  sha256 "5b528ead24bf5c999220c930d73f42ae8ef15e648fc4e864579b682847b401d9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "66dd37fad68886e7b5650fd966765a13c23ed2bbf32273c92ab19314341f0679"
    sha256                               arm64_sequoia: "0be7ea7c7218a6458211ab58dca1e7ec47123276c69efa0b57cf37ded97ed2c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11a0d4d74beb80b69fd82c0313a491b03368526569b0fe618fd6ebc5ce471471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55ba87221971deeaf52828a28526958d6568d411bc44becf313ae9ecc16bb2a7"
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
