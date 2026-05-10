class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.8.14.tgz"
  sha256 "9ff3c3378e020c884529d206c68e2b6a78eae5400b85dbfef7b0858e61911758"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25df11b797ab02e0b1cebc3ff0050fd1d1c0e56adbbf4e56cbeb02981aad6639"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25df11b797ab02e0b1cebc3ff0050fd1d1c0e56adbbf4e56cbeb02981aad6639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25df11b797ab02e0b1cebc3ff0050fd1d1c0e56adbbf4e56cbeb02981aad6639"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "759f465c7cd39ccedbfae87161f404d1f1cc7a5136eab0f9be8cac83ce1e6cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67857b1716fa29d9cbd519710ddcdc8007675cff01933ff9789504165b87a34b"
  end

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  on_linux do
    depends_on "xsel"
    depends_on "zlib-ng-compat"
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
    node_modules.glob("**/@img/sharp-*").each(&:rmtree)

    vendor_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(vendor_dir)

    node_modules.glob("**/@zed-industries/codex-acp-linux-*").each(&:rmtree)

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
