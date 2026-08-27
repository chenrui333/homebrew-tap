class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.1.7.tgz"
  sha256 "7d978906d7b02d2d94107cccdb560378af8009f00396ae26641a0a1ebe5f914e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "57252311666b467a813ef365d206ec8cba485a8da358ca3a17ef36a9d9d7023d"
    sha256                               arm64_sequoia: "57252311666b467a813ef365d206ec8cba485a8da358ca3a17ef36a9d9d7023d"
    sha256                               arm64_sonoma:  "57252311666b467a813ef365d206ec8cba485a8da358ca3a17ef36a9d9d7023d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce4949e814949dc42cb3378670c45e9c5a23d00721e010ada897de102d7b5edc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2270d0e4a05648eb7626e42b77459e19dd0aa35af5cf4b7b3972d1b880501277"
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
