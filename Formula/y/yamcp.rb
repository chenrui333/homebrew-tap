class Yamcp < Formula
  desc "Manage MCP servers and workspaces from the command-line"
  homepage "https://github.com/hamidra/yamcp"
  url "https://github.com/hamidra/yamcp/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "ed23201e068cd001dc49a837d881a44e61b4f5527dd74b735ba2ebb6c2db662d"
  license "MIT"

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
