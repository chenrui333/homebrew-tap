class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-4.1.9.tgz"
  sha256 "717f4a5f499c0139873e8274d8849f0c574ef352e03eca0f68a2ff7b30e845e6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "d7f3cfa34314560958c92110ffce85b60d9b856176182f75d6446a6c3f1f768b"
    sha256 cellar: :any,                 arm64_sequoia: "d7f3cfa34314560958c92110ffce85b60d9b856176182f75d6446a6c3f1f768b"
    sha256 cellar: :any,                 arm64_sonoma:  "d7f3cfa34314560958c92110ffce85b60d9b856176182f75d6446a6c3f1f768b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfcead420c4d1b973641d158f11f7e968432be6d4446fdde2fef8f410a059f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf028d73d3adf2fd81c832e7c0f793adc70a05743fed18695c51365a9587e0a6"
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
