class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.1.8.tgz"
  sha256 "6287f721321721138d4480b06ee92fdd86c33d909366b3aff1e57f41f294861b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "de86f3feb6bd4df77d2c4d04821cf90af2eafb6dd8e6eb993fccf12cf6039b30"
    sha256 cellar: :any,                 arm64_sequoia: "de86f3feb6bd4df77d2c4d04821cf90af2eafb6dd8e6eb993fccf12cf6039b30"
    sha256 cellar: :any,                 arm64_sonoma:  "de86f3feb6bd4df77d2c4d04821cf90af2eafb6dd8e6eb993fccf12cf6039b30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "990f7cc4d8ea90d9e5f4475ef4ac3426489bff2f22dfc52007f75b766d7857c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "498addd7a93d4e1c4dc2739d6d825c6fd17315318588af4f24ab3f448b7131ea"
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
