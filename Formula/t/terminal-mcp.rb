class TerminalMcp < Formula
  desc "Headless terminal emulator exposed via MCP for AI assistants"
  homepage "https://github.com/elleryfamilia/terminal-mcp"
  url "https://github.com/elleryfamilia/terminal-mcp/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "4f0a38362cc398978e885031a0387a63a530068d3af1d372d6c3cf68cbd54496"
  license "MIT"
  head "https://github.com/elleryfamilia/terminal-mcp.git", branch: "main"

  depends_on "node"

  def install
    system "npm", "ci"
    system "npm", "run", "build"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/terminal-mcp"

    prebuilds = libexec/"lib/node_modules/@ellery/terminal-mcp/node_modules/node-pty/prebuilds"
    if OS.mac? && Hardware::CPU.arm?
      rm_r prebuilds/"darwin-x64", force: true
    elsif OS.mac? && Hardware::CPU.intel?
      rm_r prebuilds/"darwin-arm64", force: true
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terminal-mcp --version")
    output = shell_output("#{bin}/terminal-mcp --sandbox --sandbox-config #{testpath}/missing.json 2>&1", 1)
    assert_match "Failed to load sandbox config", output
  end
end
