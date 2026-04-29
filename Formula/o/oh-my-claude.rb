class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.13.5.tgz"
  sha256 "6a7629aec2f9ce84bd4be2b15b8b87162ce0031950aa01382b20b10db66ea5d9"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1ba5e7edfb486ea6036874b0f56c902c2e7e2752e34020c29b1ed4179ad736e0"
    sha256 cellar: :any,                 arm64_sequoia: "9456a1505fc88f50537ab49867c0d945a46f1d723440365fdeb92559d5371485"
    sha256 cellar: :any,                 arm64_sonoma:  "9456a1505fc88f50537ab49867c0d945a46f1d723440365fdeb92559d5371485"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57b4b5858952151c2566d24f413fd08be97fdceffcf90354992af04b95dc2166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31d5fadd8461e924352602777c1fcb5879a2e99e1e1080d7c3a49f3d7d58a21c"
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
