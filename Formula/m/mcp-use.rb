class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.1.8.tgz"
  sha256 "6287f721321721138d4480b06ee92fdd86c33d909366b3aff1e57f41f294861b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6671a6424eb0d5fd07c9408dff72cadb6833509c73005a55ff89bfe96bd861fe"
    sha256 cellar: :any,                 arm64_sequoia: "6671a6424eb0d5fd07c9408dff72cadb6833509c73005a55ff89bfe96bd861fe"
    sha256 cellar: :any,                 arm64_sonoma:  "6671a6424eb0d5fd07c9408dff72cadb6833509c73005a55ff89bfe96bd861fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "989a5ad485f1483dcfc5d2ae51839b23c780c2ef155383b4619e7a77acedc6a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90139769294db126b8b95df7cbed28a20281b585cffdeff6d68e31c3fda1b5b5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

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
