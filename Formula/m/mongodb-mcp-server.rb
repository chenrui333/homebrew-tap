class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-3.2.1.tgz"
  sha256 "caea09d7163d5f92ff347394fbafa36861711ce39e6ffb9bc36d320c1d433f49"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "bc96a5be3890847329e2f5acdce510b50cff665bc825a539a909c9690deb5240"
    sha256                               arm64_sequoia: "bc96a5be3890847329e2f5acdce510b50cff665bc825a539a909c9690deb5240"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7137e64548caa5695a1466a1ee6c244f0e004c637f9202c45bbe511e9b60dd88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00ca55fda63627cbd508538521dc2f81473611f7d65424e2143c2e5ab7d15e0a"
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
