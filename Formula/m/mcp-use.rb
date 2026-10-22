class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.5.1.tgz"
  sha256 "cb4c076be5ef4c9d2da0162acd6c9da59a7f200d7d6912e451f9dd6d5ec72396"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ad391f61bf0ec084691a07f265118544799da7754db0bb71203fdcd657867fcd"
    sha256 cellar: :any,                 arm64_sequoia: "ad391f61bf0ec084691a07f265118544799da7754db0bb71203fdcd657867fcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "952335dd29fa922dfe36df0a00a22fa15ec67a4a4a2481844fa9b3c6457bd706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65ca47b99ae7edd9044d694a5ca7c67491783c23cec12b0db1638154c54719b3"
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
