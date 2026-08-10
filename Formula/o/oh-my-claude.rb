class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.15.9.tgz"
  sha256 "9b143a87014f26af27b7a476bf6b2e7d185bb759c9d63e18f3e1a95e441c2b6b"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "e2398e6351555dd706a50e7fa328cb12b1506ce5cefe62e9d8789e0f7a691330"
    sha256 cellar: :any, arm64_sequoia: "e2398e6351555dd706a50e7fa328cb12b1506ce5cefe62e9d8789e0f7a691330"
    sha256 cellar: :any, arm64_sonoma:  "e2398e6351555dd706a50e7fa328cb12b1506ce5cefe62e9d8789e0f7a691330"
    sha256 cellar: :any, arm64_linux:   "26cb895db0fdc542d9f2618fb9ada5f1fd5b902fa239b307c15d7d8c78cdd111"
    sha256 cellar: :any, x86_64_linux:  "713cc85b799796c6244da83a5cc408e65666bca80b53788d188f4a4b577548ea"
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

    require "open3"

    output, status = Open3.capture2e(bin/"omc", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "claude CLI not found", output
  end
end
