class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.10.tgz"
  sha256 "d8dbc440e3a0e742ee893d48b1c3ee15429cf34add90576b3203da05030a370f"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "908f4747c07f207f893e5f1baf56fa310a1fbca3a7da10105f97edeb5d265d57"
    sha256 cellar: :any, arm64_sequoia: "908f4747c07f207f893e5f1baf56fa310a1fbca3a7da10105f97edeb5d265d57"
    sha256 cellar: :any, arm64_linux:   "d9e4efad8c3ee1f6c1076c9bffa73899838b38d94999929afe6f38a8696e4715"
    sha256 cellar: :any, x86_64_linux:  "3875fe6f80436110eaed749e93578dfcb701cd73184e193f48a5bc23a28c169e"
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
