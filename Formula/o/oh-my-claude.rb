class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.8.1.tgz"
  sha256 "1d87ab16f112ac13381aa5477ccc8db36a9ebac9b0e355b381f9aed3a2bbbf7a"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "1046edcb039c981a140b36b9a73b3a5ef5886167af7baeb0f0d06789a23d5562"
    sha256 cellar: :any, arm64_sequoia: "1046edcb039c981a140b36b9a73b3a5ef5886167af7baeb0f0d06789a23d5562"
    sha256 cellar: :any, arm64_linux:   "e5f599b00b96537853a8ee83a52085db9ed2df7350931348dec0bc093ad715c8"
    sha256 cellar: :any, x86_64_linux:  "fefbd458fa3509601517ccd4cfa1f035a2d711ba6ccc708e3411224b6f7c06d9"
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
