class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-3.0.5.tgz"
  sha256 "c04dca5e910fb8b52b8565a9f47d6b11ea03537cbbf302d48e0803c0325bc58e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256                               arm64_tahoe:   "f54b140d8cb7bf2e5b16ae8a6653be549b94715d9484155e5619c272d01a9013"
    sha256                               arm64_sequoia: "f54b140d8cb7bf2e5b16ae8a6653be549b94715d9484155e5619c272d01a9013"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e84faee1e984d57db47a8df0b45e21664bb1cb7e5dfc896738339ac60b47595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "550d7310413edb542ea5411c2f8b900ea2cd19cb1dfaeeaa2191a6c31b693455"
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
