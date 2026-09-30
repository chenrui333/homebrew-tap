class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.1.17.tgz"
  sha256 "15dabea80140d64396c09fefd1f16b16d19355c7e5ec54e11196bac3afba13e6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6f04849e4eb0fdd5dd3a8bcdff507850c9fe5ae04ed3601a3cf90ada0b40db75"
    sha256 cellar: :any,                 arm64_sequoia: "6f04849e4eb0fdd5dd3a8bcdff507850c9fe5ae04ed3601a3cf90ada0b40db75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46a4258a095462b5a2bc900d66dd524d6a41a0c4f70b57628e7f1bf57fb63e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f46a49835c7364d8f3c26e1865ed930b8707f9a30dfafddfa3196fede7870fe6"
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
