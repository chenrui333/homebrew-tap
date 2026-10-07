class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.8.14.tgz"
  sha256 "9ff3c3378e020c884529d206c68e2b6a78eae5400b85dbfef7b0858e61911758"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48f7cfdac3ac6f0e59f11fa0eb23a6fd660bdc24b277e382ff482565363d8dbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48f7cfdac3ac6f0e59f11fa0eb23a6fd660bdc24b277e382ff482565363d8dbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a2c44691974330a9bfed91eea679e55ac4a9594dc1a1fc7c95acd565dcbdc09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f52306322ade37f8519672f213bdbd5cce3bbfbefba0956172fcedfc6a57523e"
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

  deny_network_access!

  def fetch
    # Allow newer better-sqlite: https://github.com/vibe-log/vibe-log-cli/pull/11
    inreplace "package.json", '"better-sqlite3": "^11.0.0"', '"better-sqlite3": "^12.0.0"'
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
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
      ln_sf (formula_opt_bin("xsel")/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibe-log --version")
    output = shell_output("#{bin}/vibe-log send 2>&1", 1)
    assert_match "Claude Code data not found", output
  end
end
