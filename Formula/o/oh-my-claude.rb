class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.8.7.tgz"
  sha256 "ea781382efd3311bc0f439c3899432be154fc1dc894004449615bc6bf2f320e6"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "4c2a4b7788299cae113ef0968bd0c40b63e767677977b53f3e4df09608a0e8ea"
    sha256 cellar: :any, arm64_sequoia: "4c2a4b7788299cae113ef0968bd0c40b63e767677977b53f3e4df09608a0e8ea"
    sha256 cellar: :any, arm64_linux:   "9f28518b170d5d72aec2437950b14d15c2860d49a3305b0c67d9e613eb8ae934"
    sha256 cellar: :any, x86_64_linux:  "43a196a65123349d23941e9eb0119414d23dc398b9373bd2a24611f44c9f6852"
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
