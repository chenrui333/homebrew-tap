class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-5.1.0.tgz"
  sha256 "78f54d016945d4ab4843cf03c1fe0ac1c78d6a592cfb4ff162a844ba719ae796"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "cb567b367e11a3d0c10b5f6dbd081ac05a55c186736e262c25035458d9084298"
    sha256 cellar: :any,                 arm64_sequoia: "cb567b367e11a3d0c10b5f6dbd081ac05a55c186736e262c25035458d9084298"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99671ce08b96e87e77bcc910e4d4f5f7e699471144f067147bda4698e5ca7a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be777ca24fc772e3d79106314ab0abba40fd0a02b5de2af34c7f359b8c866d5a"
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
