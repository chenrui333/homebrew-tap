class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.27.tgz"
  sha256 "fcaf0a7cc8a44106e2d560e9497482230973ce5877c86247d61dcc528fac37e0"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "6646dd25414772d99f18294a41db1ed384db290c6d1773cdc0963251e7b6a1fc"
    sha256 cellar: :any, arm64_sequoia: "6646dd25414772d99f18294a41db1ed384db290c6d1773cdc0963251e7b6a1fc"
    sha256 cellar: :any, arm64_linux:   "962b7100cd643887e3201fbfbc32748584b76e22b4298b04818501d461035c1d"
    sha256 cellar: :any, x86_64_linux:  "c12c2cf0af055748fe56a8774668aca74a8d1df29882b07bba9340bf47698c0a"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove vendored prebuilt ripgrep binaries that cause Mach-O relocation failures
    vendor_dir = libexec/"lib/node_modules/oh-my-claude-sisyphus/node_modules" \
                         "/@anthropic-ai/claude-agent-sdk/vendor"
    rm_r(vendor_dir) if vendor_dir.exist?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omc --version")

    output = shell_output("#{bin}/omc test-prompt 'Format a JSON record.'")
    assert_match "Enhanced prompt:\nFormat a JSON record.", output
  end
end
