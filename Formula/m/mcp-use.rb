class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.4.0.tgz"
  sha256 "056b7a475e25f90bef0d1d30f7ccde8299a7619ce3e9cdd6c2912bd85dbc5c97"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ec2a491f3073bcfdf49be09bcd96aeb12eb91ebc729cc6716f99b8036c1d18ae"
    sha256 cellar: :any,                 arm64_sequoia: "ec2a491f3073bcfdf49be09bcd96aeb12eb91ebc729cc6716f99b8036c1d18ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c86a5e0d2259a544b921c4dfd9fe88012422d3bd2ea5e3a28dd3b47306ef00f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d33acc9c0e2d310985f29816a876aa7c5445f2aea4a176cd7a4d154a74545d85"
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
