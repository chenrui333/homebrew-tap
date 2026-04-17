class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.12.0.tgz"
  sha256 "5cded5a331d59b04e9a5293b8d97769e7d98f3ace73fc7eed190f2617c422a1c"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b84c635d905dcfffac4f6af34a0d4dd62a96e78a3cc705b22886952330ea1495"
    sha256 cellar: :any,                 arm64_sequoia: "c5dad2dd861c5abd60fc1624fe88858556ace0862f5ff04681529f795a8dded4"
    sha256 cellar: :any,                 arm64_sonoma:  "c5dad2dd861c5abd60fc1624fe88858556ace0862f5ff04681529f795a8dded4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c51296dc354481536b13e0dd69f84fefacdfa24bed4aa68f0c6d800887cfb241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42ca2d934d5ab3fcf66d86872d4fd8e94d9a17b6eb37568f5e85ccc6e17f7862"
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
