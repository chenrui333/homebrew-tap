class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.8.3.tgz"
  sha256 "46f45888a430fb66cc5fa642389ae1d8e9d0b466381f6ba4f6959008e21c8269"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "efc3a51bec4f974e8bdef3e29dc567f497bc3856503f67c8f57c6fc060b8f97c"
    sha256 cellar: :any, arm64_sequoia: "efc3a51bec4f974e8bdef3e29dc567f497bc3856503f67c8f57c6fc060b8f97c"
    sha256 cellar: :any, arm64_linux:   "ce5a06ab31023748d8838a28faf5f099b171987df710117109d4c580c5440076"
    sha256 cellar: :any, x86_64_linux:  "8828b442961b213748cf312ff29c7f25b342ac21e7396e9e78dd8e5a22dffde7"
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
