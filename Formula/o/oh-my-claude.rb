class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.30.tgz"
  sha256 "d6832eb464b164c08d53bacaffdbfcadcb26adb78523613ffbf3b59de4129a47"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "8a047005bea5e16748f24744bb92f6fc4efa0796a49a37e4c15d1fc44cbc9fce"
    sha256 cellar: :any, arm64_sequoia: "8a047005bea5e16748f24744bb92f6fc4efa0796a49a37e4c15d1fc44cbc9fce"
    sha256 cellar: :any, arm64_linux:   "8d73fea4c025ea6d52b58a654f74c2639ceb59bbb8af93f4dc3f59f7a589dbc9"
    sha256 cellar: :any, x86_64_linux:  "df3f6bebeb6e6b7861a41d5bf98648672ce6db78f15b918ac38c0fc8c8d6f178"
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
