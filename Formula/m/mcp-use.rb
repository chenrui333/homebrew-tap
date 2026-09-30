class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.1.17.tgz"
  sha256 "15dabea80140d64396c09fefd1f16b16d19355c7e5ec54e11196bac3afba13e6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "3dcc0fd0245cc95cfaa7be3e6bcd5c2cb6c04a83525643de235fd77eeb9a0fbf"
    sha256 cellar: :any,                 arm64_sequoia: "3dcc0fd0245cc95cfaa7be3e6bcd5c2cb6c04a83525643de235fd77eeb9a0fbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfc6de9221525e7303f59895328f03e358fe2a2b92195d7252c153a6634444e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52165766fbd11a3883dd1c7670a51862a6695c71ef3eb98db13bf749a38b90bf"
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
