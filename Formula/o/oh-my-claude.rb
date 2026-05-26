class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.14.2.tgz"
  sha256 "a0abbbdbdb1a8a15616d7e9bcd199398f1ef9160c681a665535532e04dd9f500"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a9c7f7ae2faf8ab7ff190227e5cd027f559f9dbcfab8190f9ae1e3ab0d887a1e"
    sha256 cellar: :any,                 arm64_sequoia: "44bcf3ba6ea55ace211a6ef00cdc2feaa427442f64c5354237e7d4435763a6cf"
    sha256 cellar: :any,                 arm64_sonoma:  "44bcf3ba6ea55ace211a6ef00cdc2feaa427442f64c5354237e7d4435763a6cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1fe3ed56c20eb665d12d2599fc9eb6f9c3f8bdd60044028e65ffcb83b279093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ee26dc4049d453270301bf733565a6e1833de2e784ae6d5507a58a7b964d6f0"
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
