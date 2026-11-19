class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-5.2.0.tgz"
  sha256 "2949bd52b522f6e8564175a6ebacf1b1c7475c51415459facf4726d2271c0869"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6a1ff13051612a035db9391c94f2e7d2d6cfe2e1029f9eab03a6ebac0f60030b"
    sha256 cellar: :any,                 arm64_sequoia: "6a1ff13051612a035db9391c94f2e7d2d6cfe2e1029f9eab03a6ebac0f60030b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02cd1ab706e1c60b2b11e23c0c06ba2738d1e3af44930960238ee3f1820cba43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6df85bee2a336cf68c83e5db127d3e53fffb719a2b4ba04dfc41c8c10389460c"
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
