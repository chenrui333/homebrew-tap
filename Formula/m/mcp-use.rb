class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-5.1.1.tgz"
  sha256 "2f7f4168881c57dc85aaf8af0d7e497dca15acd82a70f36de9f24b443eb6e61c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c0eefc65e8448ef72ed7c8d650a4d1b157890f2f98176a2f6d84c7751ffa038e"
    sha256 cellar: :any,                 arm64_sequoia: "c0eefc65e8448ef72ed7c8d650a4d1b157890f2f98176a2f6d84c7751ffa038e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6758558ffcb4c1b7cc0e24933b72fa7ba663262de23ccb8bf284328f92437c9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dfc4272748334aaffb4095e256e66c86dd022eabbc14a6c949d894e32b05bce"
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
