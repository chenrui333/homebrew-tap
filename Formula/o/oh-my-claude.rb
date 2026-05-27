class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.14.3.tgz"
  sha256 "a6644932b54aec6895c9e2af379852a17ff06427e076011eacb89ad55274d9df"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "36f99ba03b857aa916e27b51e5ca7f3e1270aa543a48614c21e196f6652df6b3"
    sha256 cellar: :any,                 arm64_sequoia: "da9160f5075ada855e3e94264fa774f8ac5d246e9c13e0d4390bdfdb1567c552"
    sha256 cellar: :any,                 arm64_sonoma:  "da9160f5075ada855e3e94264fa774f8ac5d246e9c13e0d4390bdfdb1567c552"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83ab840b2704531bb44af047333d216ec12b64a1c3f5569c68e45465b1a4ceb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c69c90d3cce86b7b7e8ae6f3a7970d4a13506a6c61ae0fcfe12ca9b96ddb3b61"
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
