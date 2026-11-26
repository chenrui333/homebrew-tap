class TerminalMcp < Formula
  desc "Headless terminal emulator exposed via MCP for AI assistants"
  homepage "https://github.com/elleryfamilia/terminal-mcp"
  url "https://github.com/elleryfamilia/terminal-mcp/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "1e750bdca594826d6dddf3a28785669d002522625a341050270ee06d63c1720b"
  license "MIT"
  head "https://github.com/elleryfamilia/terminal-mcp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "0c5161064964b14fc2c3cc835baf35639f8abd23b3bbab6266c39f69e82b7c05"
    sha256 cellar: :any,                 arm64_tahoe:   "1fbedc7f4fad67e9c91931187151a14a952ab1a3b6536304dc851890d78f7890"
    sha256 cellar: :any,                 arm64_sequoia: "1fbedc7f4fad67e9c91931187151a14a952ab1a3b6536304dc851890d78f7890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb7c9205a6339b55f020ebe12c02d26a3c3f5ef7035a14e902be0b0083833862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56de8bc84c8320477f563cc1f5233524c76beb459f5e13b7965ed6f4e1721658"
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
