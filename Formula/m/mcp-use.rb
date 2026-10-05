class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.2.1.tgz"
  sha256 "41c2fa8c3c28e3f89425d0c1db98c5a73c2599b0aad2bdbd8d70eba925378e1d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "7fa11bb93fc8976e2b1a58d140dc526cc6c860a5453811c5fd11c2ab10b95ff0"
    sha256 cellar: :any,                 arm64_sequoia: "7fa11bb93fc8976e2b1a58d140dc526cc6c860a5453811c5fd11c2ab10b95ff0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e933c186d2c42ea8b662a2e4c5b11bccf46ea23c2fe34b1e3c807f32b716c766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3b1bb2373c51677e43f585d996c23ac14f36a51e24bdddfdd9bbdc5133a9db1"
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
