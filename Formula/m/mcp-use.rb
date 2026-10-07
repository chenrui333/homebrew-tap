class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.3.0.tgz"
  sha256 "e4faba374779db93bb4b6f89b8731182274f30af5d4e91206e9083f6629253fb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "02d4cc583461abd1b22c920fb80b8d20c72f22602143577faec3ac4554ffef41"
    sha256 cellar: :any,                 arm64_sequoia: "02d4cc583461abd1b22c920fb80b8d20c72f22602143577faec3ac4554ffef41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d54231baef5b70b1d7bcef732a0a477274c60d6bf437851998750dbcad6d8f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "641fbbbfa8b38ecca11cb79d4428f0c10946a11c31b5a5bf6bf9d7d6b501f0e7"
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
