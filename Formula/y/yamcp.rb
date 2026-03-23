class Yamcp < Formula
  desc "Manage MCP servers and workspaces from the command-line"
  homepage "https://github.com/hamidra/yamcp"
  url "https://github.com/hamidra/yamcp/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "ed23201e068cd001dc49a837d881a44e61b4f5527dd74b735ba2ebb6c2db662d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7b86a46d0250d9e14bda023910cf3f69e8e4f88bb7eec4dc9968cd1e36168e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39e2cd06cd95a0bb5a01f4f740ef286da0f41518805b9c045812a0bdd53963c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d12aaeb306743bbf62f732e651b20dfc78f8fcd41d950e48996fa23b531df3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17e75405310a61b0adb2f2b7659708a7b226f1f460af0c7460164a5a51255446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b12c445c02aff67924c3df1df979d79dedcd0681aa5d85c4232302581db030b"
  end

  depends_on "node@24"

  def install
    node_path = "#{Formula["node@24"].opt_bin}:#{Formula["node@24"].opt_libexec/"bin"}:$PATH"

    ENV.prepend_path "PATH", Formula["node@24"].opt_bin
    ENV.prepend_path "PATH", Formula["node@24"].opt_libexec/"bin"

    system "npx", "-y", "pnpm@9.15.0", "install", "--frozen-lockfile"
    system "npx", "-y", "pnpm@9.15.0", "run", "build"
    system "npx", "-y", "pnpm@9.15.0", "prune", "--prod"

    libexec.install "dist", "node_modules", "package.json"
    chmod 0755, libexec/"dist/index.js"
    (bin/"yamcp").write_env_script libexec/"dist/index.js", PATH: node_path
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamcp --version")
    assert_match "No MCP servers configured", shell_output("#{bin}/yamcp server list")
  end
end
