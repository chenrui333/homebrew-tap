class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.2.1.tgz"
  sha256 "41c2fa8c3c28e3f89425d0c1db98c5a73c2599b0aad2bdbd8d70eba925378e1d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b6ca60e17cb8110fd77ff3f6a433aa97df44d821a8e8ebffb8a7ec9fde7c4f6e"
    sha256 cellar: :any,                 arm64_sequoia: "b6ca60e17cb8110fd77ff3f6a433aa97df44d821a8e8ebffb8a7ec9fde7c4f6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6336862f4fe9e06dd8cf94fe3d31b4ff7736fbdc64b5e0f69e224dd7001c946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb54250dc1edc4498845936d2c79652e93d7919011843446fd7df61645baf1e9"
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
