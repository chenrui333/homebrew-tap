class TerminalMcp < Formula
  desc "Headless terminal emulator exposed via MCP for AI assistants"
  homepage "https://github.com/elleryfamilia/terminal-mcp"
  url "https://github.com/elleryfamilia/terminal-mcp/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "869ab8dc573c38295f265a1176561079147b020f423bdd7c3a9f797a81d4cfb4"
  license "MIT"
  head "https://github.com/elleryfamilia/terminal-mcp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "148ba8b7918fe18d8243e949227a89b83443707f0953d9c5490890474a5acb29"
    sha256 cellar: :any,                 arm64_sequoia: "1ac3d3c0ee90df448e7dd852fb5edbc43244bdcec9bd77546ed7b3d83d91059d"
    sha256 cellar: :any,                 arm64_sonoma:  "1ac3d3c0ee90df448e7dd852fb5edbc43244bdcec9bd77546ed7b3d83d91059d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ac147f01aa794be0663907c9628388642ac11547d15e08c896c34e20153628e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8b2c62ed9391b31f6a79cf5563737cb92b1e440ac4b2c3dd5d1c8e217a5fd11"
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
