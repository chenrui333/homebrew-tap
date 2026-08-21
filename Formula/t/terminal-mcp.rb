class TerminalMcp < Formula
  desc "Headless terminal emulator exposed via MCP for AI assistants"
  homepage "https://github.com/elleryfamilia/terminal-mcp"
  url "https://github.com/elleryfamilia/terminal-mcp/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "be36a319e0ff839118bdfb38a2517eed3d0956f79ded90118602792b19ef158e"
  license "MIT"
  head "https://github.com/elleryfamilia/terminal-mcp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ad0b8007823f4f7f98b8f51979649f51c5a52f2908b4f97fd785ba1a50254a7c"
    sha256 cellar: :any,                 arm64_sequoia: "ad0b8007823f4f7f98b8f51979649f51c5a52f2908b4f97fd785ba1a50254a7c"
    sha256 cellar: :any,                 arm64_sonoma:  "ad0b8007823f4f7f98b8f51979649f51c5a52f2908b4f97fd785ba1a50254a7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17b0869b7ff41d1b376b1d9835a7bfbee0293f11aab3d5b79a4d28d4c7f9de55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c36295eed483b2d0f655d7c543eaaa04a2848a60ae7daf1de646448ff495f970"
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
