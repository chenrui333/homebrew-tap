class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.1.10.tgz"
  sha256 "f4d5544c57d4a79fb76374fec7fad819b62872917151fa48dbe319e2aad1f868"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "23df980b55d2497551ce067cf0c35e5a675b836fbde54141a8a48879da006333"
    sha256 cellar: :any,                 arm64_sequoia: "23df980b55d2497551ce067cf0c35e5a675b836fbde54141a8a48879da006333"
    sha256 cellar: :any,                 arm64_sonoma:  "23df980b55d2497551ce067cf0c35e5a675b836fbde54141a8a48879da006333"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "868e1383575b46f0579b3d33db2d8b95451887bcea5c33ee667065fe5950279b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52273ab3555772d10cdaa8231e1a2d87e040442bbdf182fa0a2527e3d1610ce9"
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
