class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.0.0.tgz"
  sha256 "f803175a20afc9f57a274c0e9483e5437207774618f9f60c01a287f9ff8c421d"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "cd948ce7b07c0632d214c6996a472c1e09779bef23ecd43e799b28258ddc7530"
    sha256 cellar: :any, arm64_sequoia: "cd948ce7b07c0632d214c6996a472c1e09779bef23ecd43e799b28258ddc7530"
    sha256 cellar: :any, arm64_sonoma:  "cd948ce7b07c0632d214c6996a472c1e09779bef23ecd43e799b28258ddc7530"
    sha256 cellar: :any, arm64_linux:   "ae1d6c90775c4626cb924c1e2226d8e0c894151dffeddca97b533ac0d0aa931c"
    sha256 cellar: :any, x86_64_linux:  "647a115cbae6a55660afbafdee1fe94c6c28ec2e54c4bff537edf987c8492a0d"
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
