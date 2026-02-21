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
    native_prebuild = if OS.mac?
      Hardware::CPU.arm? ? "darwin-arm64" : "darwin-x64"
    elsif OS.linux?
      Hardware::CPU.arm? ? "linux-arm64" : "linux-x64"
    end

    if prebuilds.exist? && native_prebuild
      prebuilds.children.each do |path|
        rm_r path, force: true if path.basename.to_s != native_prebuild
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terminal-mcp --version")
    output = shell_output("#{bin}/terminal-mcp --sandbox --sandbox-config #{testpath}/missing.json 2>&1", 1)
    assert_match "Failed to load sandbox config", output
  end
end
