class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.2.1.tgz"
  sha256 "41c2fa8c3c28e3f89425d0c1db98c5a73c2599b0aad2bdbd8d70eba925378e1d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e7cdd63a28029757e46e0466404193d273d39dba508847443a89a93a1d1956aa"
    sha256 cellar: :any,                 arm64_sequoia: "e7cdd63a28029757e46e0466404193d273d39dba508847443a89a93a1d1956aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "047181ddba030ab3e87a809adbcbc6f470e6c53c87ed121ae7578b69f2afb6a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f4979db0d1380055c21b0310801fee1364a2fbecd10603ddd2044555de35872"
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
