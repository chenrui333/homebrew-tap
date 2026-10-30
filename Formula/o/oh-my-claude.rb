class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.20.tgz"
  sha256 "40a6f87ae1309591dd54e55f63cd10b1fbcc9b3f996d74d8e5eaa61bea245849"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "3b462aec796501fb66e8f96e6c814738b1b0f0bf93da894241cd4d57a16d0028"
    sha256 cellar: :any, arm64_sequoia: "3b462aec796501fb66e8f96e6c814738b1b0f0bf93da894241cd4d57a16d0028"
    sha256 cellar: :any, arm64_linux:   "6f19063c4176fa380ebee65bcd8d8a9bb2cf6f41a6e30aefb675bbe1702f1e77"
    sha256 cellar: :any, x86_64_linux:  "92945ac0603a69ae4f19eb99946da3188925bad418944fb7775bb2bfd7a55a7e"
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
