class TerminalMcp < Formula
  desc "Headless terminal emulator exposed via MCP for AI assistants"
  homepage "https://github.com/elleryfamilia/terminal-mcp"
  url "https://github.com/elleryfamilia/terminal-mcp/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "ccd436a7949d32368cdc26184099c507781cd02157d99481fe7e1ebc85e8009b"
  license "MIT"
  head "https://github.com/elleryfamilia/terminal-mcp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "23b58d89282b8579d3828f2c20c58c9ad5b1327ec548cb82fa75b2f9d96536fc"
    sha256 cellar: :any,                 arm64_sequoia: "bf750799577b6d2047bd887c422185067f7c93ab4c98bb1edac2258e8b484d28"
    sha256 cellar: :any,                 arm64_sonoma:  "bf750799577b6d2047bd887c422185067f7c93ab4c98bb1edac2258e8b484d28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fa617ff3efad91581edaec147b6e726e419e3d06f6ee5f5276e2f83c194d562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da2c436a5096d99f6533e3207248f3b262da2ce801c5e70c3fa2272b8404982b"
  end

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

    return unless OS.linux?

    native_seccomp = Hardware::CPU.arm? ? "arm64" : "x64"
    seccomp_root = libexec/"lib/node_modules/@ellery/terminal-mcp/node_modules/@anthropic-ai/sandbox-runtime"
    [seccomp_root/"dist/vendor/seccomp", seccomp_root/"vendor/seccomp"].each do |path|
      next unless path.exist?

      path.children.each do |child|
        rm_r child, force: true if child.basename.to_s != native_seccomp
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terminal-mcp --version")
    output = shell_output("TERMINAL_MCP=1 #{bin}/terminal-mcp 2>&1", 1)
    assert_match "cannot be run from within itself", output
  end
end
