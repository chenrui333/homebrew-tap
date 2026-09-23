class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-3.0.4.tgz"
  sha256 "5b528ead24bf5c999220c930d73f42ae8ef15e648fc4e864579b682847b401d9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "da8c82515e02d9f514fb5f0d66aeb47b896a7cec7ccf071e1e46ec4ef1fa68e4"
    sha256                               arm64_sequoia: "da8c82515e02d9f514fb5f0d66aeb47b896a7cec7ccf071e1e46ec4ef1fa68e4"
    sha256                               arm64_sonoma:  "da8c82515e02d9f514fb5f0d66aeb47b896a7cec7ccf071e1e46ec4ef1fa68e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6284c4ab5038c0d9185c7fc994cb59452f416d970fc2682055ca8e234cdea45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29aed6abe4ce81ee3d14c771d1cda27c372ad2bd18e3c913f039141ada8e0672"
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
