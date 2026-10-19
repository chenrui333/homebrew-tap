class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.5.tgz"
  sha256 "24e85fec68af90adf52d5f97ae39b29cbf455c5219557e9de0a768b565768de2"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "182df3a4e586443e77bb5516764f89d34dcfda6eff1a6ca264f78b7715cf3e9c"
    sha256 cellar: :any, arm64_sequoia: "182df3a4e586443e77bb5516764f89d34dcfda6eff1a6ca264f78b7715cf3e9c"
    sha256 cellar: :any, arm64_linux:   "bfc21c23aef3c1c003a73b2ef1bcdb3fda2b3ace8e277e220f62ffd608688bf0"
    sha256 cellar: :any, x86_64_linux:  "8af490ea429fe8bb24d582c891390bd7dcbeafff1903e945398fceab75997f2e"
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
