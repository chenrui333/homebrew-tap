class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-5.4.0.tgz"
  sha256 "4122430b4294a816a5aab7c680516ee7c51aad827b8b48a4dbe22e2b979275a8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "062ae4c460bd5efaeb645b16b21d62e7d1a9f485c206cdb809dea5ac0b3df16d"
    sha256 cellar: :any,                 arm64_sequoia: "062ae4c460bd5efaeb645b16b21d62e7d1a9f485c206cdb809dea5ac0b3df16d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6520a61b41d0e90b91bb69a05770e5e693ad3dafab8bb8ef1e72eece2f02fc0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43b99056f6a4b9a92d49d1613cb123de1b7d3b0442c8cef7addd3b3617f2816d"
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
