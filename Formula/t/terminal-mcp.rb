class TerminalMcp < Formula
  desc "Headless terminal emulator exposed via MCP for AI assistants"
  homepage "https://github.com/elleryfamilia/terminal-mcp"
  url "https://github.com/elleryfamilia/terminal-mcp/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "be36a319e0ff839118bdfb38a2517eed3d0956f79ded90118602792b19ef158e"
  license "MIT"
  head "https://github.com/elleryfamilia/terminal-mcp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a4cb3f5417d58ceeb6d0db60f1ab89ee9046c785d9b532ca6dbfc145d7254da1"
    sha256 cellar: :any,                 arm64_sequoia: "a4cb3f5417d58ceeb6d0db60f1ab89ee9046c785d9b532ca6dbfc145d7254da1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf6f624fb988595ef5d77a208c96ea36844a74b21a1c2a74b7a7d11d352aa33b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc11521b0e0a2310ae5b7d45a54f0178c7ac5f577acbdd2d78a01a468fb116e3"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "ci"
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "run", "build"
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
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
