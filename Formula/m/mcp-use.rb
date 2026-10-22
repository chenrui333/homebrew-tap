class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.5.2.tgz"
  sha256 "c82c173ad6ef57d28cb8302aaa0cc18f71ab8013d62f976357271ecfe75ec519"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "7d873642e756dde8a8b711dc30582aa42ec374a388c720e29756ed4ee0d43d9b"
    sha256 cellar: :any,                 arm64_sequoia: "7d873642e756dde8a8b711dc30582aa42ec374a388c720e29756ed4ee0d43d9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "086704657b55ecdf1893eaba9876482dd14397c48a2e8bcf9aeddf9ff4393016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e62168aab32e2c0f29a5a8edd661bd6fbcfda99d0ef1064bed5e2222438697ba"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args

    if OS.linux?
      # ext-apps vendors Bun platform packages; keep glibc builds but remove
      # musl variants to satisfy linkage checks on Homebrew Linux runners.
      libexec.glob("lib/node_modules/**/@oven/bun-linux-*-musl*").each(&:rmtree)
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-use --version")
    assert_match "Not logged in", shell_output("#{bin}/mcp-use whoami 2>&1", 1)
  end
end
