class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.9.tgz"
  sha256 "830f77798769ff369df615b2fcd4651182d329f2639ebf3481de48a22447f0e0"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "1c73d0247389417993640cc6a6d9c3cddc8141ed392e8ea36cd416dc99a4477d"
    sha256 cellar: :any, arm64_sequoia: "1c73d0247389417993640cc6a6d9c3cddc8141ed392e8ea36cd416dc99a4477d"
    sha256 cellar: :any, arm64_linux:   "ae3016376de43d7a884ffd3fb2515ea34d27c0091f0886b8f5e3dc1dd20601f9"
    sha256 cellar: :any, x86_64_linux:  "65cceb829f1f01e334a0efd041fb329924d37afeac4914f1cdd4329aaab01d35"
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
