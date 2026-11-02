class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.24.tgz"
  sha256 "a6472024a92c51f5ee922858880c268c894b9df23fddc762217063ae8a15e1e2"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "ebabbe343487e4dbfc4ff12d58fe80c3ee943d4b215e344ca08b28450896dd1e"
    sha256 cellar: :any, arm64_sequoia: "ebabbe343487e4dbfc4ff12d58fe80c3ee943d4b215e344ca08b28450896dd1e"
    sha256 cellar: :any, arm64_linux:   "6807d2042d09701b2d3f131ee88421eb390ae4c1d4745e1dd81fdb812440cccd"
    sha256 cellar: :any, x86_64_linux:  "d52942d75e42867b491b97d70a53c6d83a0fd1bcd2921aa6043de21d715d4f3c"
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
