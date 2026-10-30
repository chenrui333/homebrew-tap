class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.20.tgz"
  sha256 "40a6f87ae1309591dd54e55f63cd10b1fbcc9b3f996d74d8e5eaa61bea245849"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "7a1cb51e49f164f4938a6fc8a049a2b55463a6d4709df2d0c7aea5ec8169178a"
    sha256 cellar: :any, arm64_sequoia: "7a1cb51e49f164f4938a6fc8a049a2b55463a6d4709df2d0c7aea5ec8169178a"
    sha256 cellar: :any, arm64_linux:   "88c1a803c44d5908bc5761f20557a419550eec07b2c5268d9904c8eb6e9b008a"
    sha256 cellar: :any, x86_64_linux:  "b130fc1b5d586fb9f1374a6b0e80e41e875fcc65bc787b3ea846277e1403d4ed"
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
