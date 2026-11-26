class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-5.4.1.tgz"
  sha256 "4b09f978284d7495c3dbea0de834a72f80f2b9b2c89ebb38825b78124b9d9344"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "ff88b0b69df7f5f1015b5bf93142e689dd6ef30e1d96b501193fca24670aaeb2"
    sha256 cellar: :any,                 arm64_tahoe:   "a140276b6e0da80b5f89e3d105915cdc1dcfb4967218f6c4cfb4052a6897971f"
    sha256 cellar: :any,                 arm64_sequoia: "a140276b6e0da80b5f89e3d105915cdc1dcfb4967218f6c4cfb4052a6897971f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "825dabd56720f7f3e3d25959a916affa491bc19311612a7ddc65f7ec34d706d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30003f3393cb8fdde7802ce8442c3ae490e82d4a8002bda41e7e4656238ef394"
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
