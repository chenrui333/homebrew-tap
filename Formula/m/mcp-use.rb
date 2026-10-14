class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.3.3.tgz"
  sha256 "1c248ddac00e017764faa9bc75aed3e8567d6e7a1ff4147fde791e0d94a9bb5b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "302a2ff222602e74c6ad34a7b73844737ddaace9490aab87816418c09fcaeead"
    sha256 cellar: :any,                 arm64_sequoia: "302a2ff222602e74c6ad34a7b73844737ddaace9490aab87816418c09fcaeead"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee94c549d787a28babc5c8868458871f1706a42a3d412622604d9c24d0e334dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1df6d70dc83a17a1d88a5f9be158efc2f54f5156f47aeff55aa09cfc0b6ae4bc"
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
