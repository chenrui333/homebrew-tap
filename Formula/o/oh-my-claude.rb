class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.18.tgz"
  sha256 "a0ee474128b45a5d25f34184bc70ff972b4cd1276696e184cd63ce4e2a017dfd"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "3576f00a7f0efef0986f5ef8841c247e8ebf06f94ba97f3443ad3eba9932c220"
    sha256 cellar: :any, arm64_sequoia: "3576f00a7f0efef0986f5ef8841c247e8ebf06f94ba97f3443ad3eba9932c220"
    sha256 cellar: :any, arm64_linux:   "c843086f3b6c290d4bbae0fdf6c5a266749ec3c8906f64a4736e25a9ace3cf5d"
    sha256 cellar: :any, x86_64_linux:  "073bd893bc6727c017c02da119d9cb0b121980a864459233a57f512503d745d9"
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
