class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-3.2.2.tgz"
  sha256 "59c4ce86edf20d6025a6c50d34321196915e1e2f3fe89b122b8c47b45e18e09c"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "95ba424f4a27d7d46139df0144c8e58d88c51fb7d1abc7acb3cb1a5972563de2"
    sha256                               arm64_sequoia: "95ba424f4a27d7d46139df0144c8e58d88c51fb7d1abc7acb3cb1a5972563de2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51e9b150823ae01f832c4cf461754c59a41977fe956d1e9208d2fb45158fedd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac921affa067a15c001dbd735e3e121bc51ec5807ca2d832be4a8dcf191eee65"
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
