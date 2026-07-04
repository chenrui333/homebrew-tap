class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.15.2.tgz"
  sha256 "346c03b17e697fdf07215c591773409266ce011ef93b7a86dc3ab3a75fd812fa"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "3b8c388d93a08a9c7437d6400ef6d75c81c098e61aa9d44a9b0063702d888c41"
    sha256 cellar: :any, arm64_sequoia: "25d2449e306ec52770444d98b707ffce209e018ff35f859fb5dc206417eaba39"
    sha256 cellar: :any, arm64_sonoma:  "25d2449e306ec52770444d98b707ffce209e018ff35f859fb5dc206417eaba39"
    sha256 cellar: :any, arm64_linux:   "8cee3a4102c645b2ebab20a8b06bf973eae5d0c8f9dad5042dd59ee7427a57cd"
    sha256 cellar: :any, x86_64_linux:  "e4c78e72cedb9cacc26405003fa47118d4b895286005c13f973636e287c2a764"
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
