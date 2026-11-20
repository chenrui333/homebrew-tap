class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-5.4.0.tgz"
  sha256 "4122430b4294a816a5aab7c680516ee7c51aad827b8b48a4dbe22e2b979275a8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5d2d9ebe35b252e6ba7f0ca06e73ac3e87517a277c8c3a2d5a9485e7315531ca"
    sha256 cellar: :any,                 arm64_sequoia: "5d2d9ebe35b252e6ba7f0ca06e73ac3e87517a277c8c3a2d5a9485e7315531ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "245ddb19741beb1471fcee0bdd4cdcf0d1a29f34b2f80baa3dd0b8e1aefdb136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fb24e415ff36b69729034808b88e6ffe69ec8bdddd1187c4c3e28b365cb46e2"
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
