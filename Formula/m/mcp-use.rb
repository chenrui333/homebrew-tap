class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.3.2.tgz"
  sha256 "ee22f44d461bee2b83e619fcac5589c568c93c27effafcedf13aff0dd5a7cf73"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "f48bf4046812cf6b109b12416f2e986f97742abb70c6fcfeeda61691362130a9"
    sha256 cellar: :any,                 arm64_sequoia: "f48bf4046812cf6b109b12416f2e986f97742abb70c6fcfeeda61691362130a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e27d267849e5ca8210c23187690eafcefb7b403f5052e2cb504a3bcbdcfe0d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "793993d420523b29a9b079df890c5544032a23988d543d0a436f2f4026ff7962"
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
