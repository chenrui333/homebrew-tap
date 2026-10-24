class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.11.tgz"
  sha256 "291f40a08c227aa2a5c0875491586b547e62d725c1f03fbd253b190857a21655"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "7a0324d320a8eda7c225f8397bdeb875ed6ea2220527a49fcfb83b1ca2594492"
    sha256 cellar: :any, arm64_sequoia: "7a0324d320a8eda7c225f8397bdeb875ed6ea2220527a49fcfb83b1ca2594492"
    sha256 cellar: :any, arm64_linux:   "b1b5dc4576e05061e4c432ed8943fd6a228a27da8aecc2c7cda5451c330fa439"
    sha256 cellar: :any, x86_64_linux:  "9a1345195555dba6c2788a95ee50c8146003d85e7e4064ac4b7bd65b7695f3f0"
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
