class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.1.14.tgz"
  sha256 "c22057fa85779ff2bdfc2e48142ffabdd37aabbfee58526ddd8516884cdb7b67"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "d172158315138c4dd4eb3727bce0fa0c3fd413d8d690a1410ae766029346d94b"
    sha256 cellar: :any,                 arm64_sequoia: "d172158315138c4dd4eb3727bce0fa0c3fd413d8d690a1410ae766029346d94b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b913126ad5627c508d18facdae584bbeb55a6bc5eec28ad1ff3586f7128a86d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d10e0fc2f944f0409e3a01e3e329250960e23b017a5185f0010c29a960c68c0e"
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
