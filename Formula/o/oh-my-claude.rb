class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.13.3.tgz"
  sha256 "2d8adeaa155bba4d417f48024cb0761aac1e0b53042515e873d347b4097ca53f"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "f15cc2ba2afb124ce34ed2a5361c01b189746e3577cb2a82fbd414aa0c234e64"
    sha256 cellar: :any,                 arm64_sequoia: "26fd9223f41c8482938ce0d008cfda7f133f76a53dc1787d4392816955d7500c"
    sha256 cellar: :any,                 arm64_sonoma:  "26fd9223f41c8482938ce0d008cfda7f133f76a53dc1787d4392816955d7500c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd919e504144b1213af3c999bf8dd256c786aaa92de868321c57b5d25b87917a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ea0cb15e99172213a9aeb14e9ccc56cb2ca828dbc205ce4b676104e1fe9092e"
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
