class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.4.1.tgz"
  sha256 "7d764ef8f6f8146397a1a4fc46da7d03c760cd5026f653b2f4c4d6c9442e370e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "3765d0b6b9dd98f142f8c6044c074dddf5633bd163c3d8cae2429b01c447d9c4"
    sha256 cellar: :any,                 arm64_sequoia: "3765d0b6b9dd98f142f8c6044c074dddf5633bd163c3d8cae2429b01c447d9c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69c227169970d269c77858dcebb0b538794e8a7710b1efc2697863253e67eab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86d1ce1159c963739d31aff8ec871c04bb6d43b44bcf5e8d6888a31565ff48a3"
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
