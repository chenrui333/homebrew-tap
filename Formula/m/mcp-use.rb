class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.3.2.tgz"
  sha256 "ee22f44d461bee2b83e619fcac5589c568c93c27effafcedf13aff0dd5a7cf73"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "07b2ac9747fef1d63d1df9dc28623c62264256b098a196a9dda22949f9635ff2"
    sha256 cellar: :any,                 arm64_sequoia: "07b2ac9747fef1d63d1df9dc28623c62264256b098a196a9dda22949f9635ff2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f998147283ecf2d52ed318a96212f7aa846aeca3f6f781fcf0ac9a8d6f220d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f5a0024b8ae7fbe2e1f04fc619cb0095bf9dad29301733a5e1a47ca51ad99a5"
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
