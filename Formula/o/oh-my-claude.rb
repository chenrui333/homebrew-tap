class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.8.2.tgz"
  sha256 "2827efa7616742e8b9e8f3124cce4f13f26a3c6b11f77e1126cfb44f50f07ad4"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "ee4888cae0dfc4fa61ca24517a95a784bc995ba9f822b1590be846d7488a1819"
    sha256 cellar: :any, arm64_sequoia: "ee4888cae0dfc4fa61ca24517a95a784bc995ba9f822b1590be846d7488a1819"
    sha256 cellar: :any, arm64_linux:   "a29c525a0c4688e13ce54673087bdaea40d521fe02b07a9961123ab090e09f95"
    sha256 cellar: :any, x86_64_linux:  "4268b0ace33b50d7ca7cab476533ebd60f7b76a81f62fed19391782f8b680ced"
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
