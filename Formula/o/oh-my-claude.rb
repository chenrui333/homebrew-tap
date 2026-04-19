class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.12.1.tgz"
  sha256 "90f8a3837e0b020289b327de858abc0b34dca9e278cf70619d25e8772fa6f571"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "73e0963ff418643d6656a446c544fb0024451665cb35f902a5f7f837d4ac1e3a"
    sha256 cellar: :any,                 arm64_sequoia: "aa957cf760a012862352861e9e44a86c43eb58988a180fe17c6c08264808d419"
    sha256 cellar: :any,                 arm64_sonoma:  "aa957cf760a012862352861e9e44a86c43eb58988a180fe17c6c08264808d419"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75c350f6b2c9c354eeabbe17f7de018f7e9c220e82c444cf3b2dc03a8e4bf98b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a032d4b9bd1978e94f14a9021c97f6353a7f474c18c93bf6b4c5b2c8ea93c826"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove vendored prebuilt ripgrep binaries that cause Mach-O relocation failures
    vendor_dir = libexec/"lib/node_modules/oh-my-claude-sisyphus/node_modules" \
                         "/@anthropic-ai/claude-agent-sdk/vendor"
    rm_r(vendor_dir) if vendor_dir.exist?
  end

  test do
    pkg = libexec/"lib/node_modules/oh-my-claude-sisyphus/package.json"
    assert_match version.to_s, shell_output("node -p \"require('#{pkg}').version\"").strip

    output = shell_output("#{bin}/omc --help 2>&1")
    assert_match "omc", output
  end
end
