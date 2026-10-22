class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.6.tgz"
  sha256 "f41f02b6f5175caf56f3bb5c42a3747ef40bdb54f15e45a39d952fe719834b6c"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "1fefc67c149ca6f7dbb08daff32127e80be984421c318582f5b6a3897c8c6782"
    sha256 cellar: :any, arm64_sequoia: "1fefc67c149ca6f7dbb08daff32127e80be984421c318582f5b6a3897c8c6782"
    sha256 cellar: :any, arm64_linux:   "2db7656712b6feeb5d75fd2e54d817486cdbb63d2bc25c96829d23a46d69144e"
    sha256 cellar: :any, x86_64_linux:  "f9b98e95a53d7c52836a83b78ccf2f874cf144ec13c700022dd56d742d840977"
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
