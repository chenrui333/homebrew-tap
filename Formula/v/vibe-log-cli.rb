class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.8.6.tgz"
  sha256 "25c321dcf0ac2c53eec2cb4b0d8756d0b074e31948ed9dce85a690d7a38f65de"
  license "MIT"

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  on_linux do
    depends_on "xsel"
  end

  fails_with :clang do
    build 1699
  end

  def install
    # Allow newer better-sqlite: https://github.com/vibe-log/vibe-log-cli/pull/11
    inreplace "package.json", '"better-sqlite3": "^11.0.0"', '"better-sqlite3": "^12.0.0"'
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/vibe-log-cli/node_modules"
    vendor_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(vendor_dir)

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibe-log --version")
    assert_match "Failed to send sessions", shell_output("#{bin}/vibe-log send --silent 2>&1")
  end
end
