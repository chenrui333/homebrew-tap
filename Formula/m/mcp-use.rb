class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.5.4.tgz"
  sha256 "c29d9e55c3c5146de79f440dd573db37622cad962feea3756646854145f91a8c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "74bf7fe2f608a27a6eac07e595dc77d514c387e047ac412856211557ef263625"
    sha256 cellar: :any,                 arm64_sequoia: "74bf7fe2f608a27a6eac07e595dc77d514c387e047ac412856211557ef263625"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e69be2ef824d657da0ae08ce2f9931427af1ccf9991e83957c7cde30c631040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4528db51c34fbb5ad02b51080733b7759f0cf35ed5642472815cefa54069e98"
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
