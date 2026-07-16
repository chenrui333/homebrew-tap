class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.15.5.tgz"
  sha256 "7df8655c2944b4125d4ff7847c74e91d6a79107b16a61440f428c87132ae11de"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "85e39f094527f4bd49dea0a5d49982fc6716002d870a6a32a4325c2dbac9460d"
    sha256 cellar: :any, arm64_sequoia: "fb447b1c90ebb3b77df347e50d38a55af728e88be5e971e7a3bdd736a872da68"
    sha256 cellar: :any, arm64_sonoma:  "fb447b1c90ebb3b77df347e50d38a55af728e88be5e971e7a3bdd736a872da68"
    sha256 cellar: :any, arm64_linux:   "610f6c2c4bb4f37220984c14d66bb9eb630967bd7d30fec39a23db423a4e2026"
    sha256 cellar: :any, x86_64_linux:  "99e2dc9a8032ba7837225f12c3e9a3751d5f2fc413722f0c5d8a7c31126c6a78"
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
