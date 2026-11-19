class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-5.1.1.tgz"
  sha256 "2f7f4168881c57dc85aaf8af0d7e497dca15acd82a70f36de9f24b443eb6e61c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "34dd1a1fb1fd00cc439a939854803a3ad8b1d996f9d178a2721f5a9de735b919"
    sha256 cellar: :any,                 arm64_sequoia: "34dd1a1fb1fd00cc439a939854803a3ad8b1d996f9d178a2721f5a9de735b919"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb15a8f3c5cfa27846b67bcd957594c2bbc7b1a237439520780f6f41f5efb9d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b82b808418c9cdee0c1db27cf9aa89270e40c15da0479d10f04877b9e15ecf1"
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
