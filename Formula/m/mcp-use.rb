class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.5.1.tgz"
  sha256 "cb4c076be5ef4c9d2da0162acd6c9da59a7f200d7d6912e451f9dd6d5ec72396"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c1af8f9d28a096ba64b2fc811c056aba750281cecaf4a6867b758c22227b0c47"
    sha256 cellar: :any,                 arm64_sequoia: "c1af8f9d28a096ba64b2fc811c056aba750281cecaf4a6867b758c22227b0c47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98b25fd3ee79b128479bdfaaae19e4e407d81ad6f8b79f20b5e38a8448e9a557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fcb1c95b5440f10752a4df7982b728f9748aca4f2a8ba9706dd01519c4c6c83"
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
