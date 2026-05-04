class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.8.6.tgz"
  sha256 "25c321dcf0ac2c53eec2cb4b0d8756d0b074e31948ed9dce85a690d7a38f65de"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8b6008cb061f1ad6744157e2596175392f308b19954667778b7e144828c3f2a1"
    sha256 cellar: :any,                 arm64_sequoia: "64a9d5f3690eee22d5c89d96a6996f0ae6a16128450a988900a2eb5251e5fb86"
    sha256 cellar: :any,                 arm64_sonoma:  "64a9d5f3690eee22d5c89d96a6996f0ae6a16128450a988900a2eb5251e5fb86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10b349e0a3629982a2a63e301e981257bdc204eec91a73057d80977e71c4f395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "926e609132b4e9d1aac3c1d0727fbe085e2ac2031735770778d9a520bb2e1c53"
  end

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
