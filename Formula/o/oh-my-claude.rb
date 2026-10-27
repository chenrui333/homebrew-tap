class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.16.tgz"
  sha256 "2957534030c4630dc26c49b1524c6815986daf728ebb87bfbe2297368257502d"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "a07cfaaf844519d176263a17399f9d587f945e04de6d77fe5c4afa509fee690f"
    sha256 cellar: :any, arm64_sequoia: "a07cfaaf844519d176263a17399f9d587f945e04de6d77fe5c4afa509fee690f"
    sha256 cellar: :any, arm64_linux:   "53f19cb2f2164572e86d83d06301f50dcddfbc7d97a40a6c54ec7ce294f49b38"
    sha256 cellar: :any, x86_64_linux:  "631a0c24aba3c56ac1c1fb01abe7516036fb67427b7a3e78c99530dfe6113764"
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
