class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.15.7.tgz"
  sha256 "1844af3d97e064742de82c81973c58402c089f0e99a8f3fc3b52f4d136bc18d7"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "cf057d53bdac90e3b7439f4adc087d20f10262d35730ce0b2a92b906208c129f"
    sha256 cellar: :any, arm64_sequoia: "cf057d53bdac90e3b7439f4adc087d20f10262d35730ce0b2a92b906208c129f"
    sha256 cellar: :any, arm64_sonoma:  "cf057d53bdac90e3b7439f4adc087d20f10262d35730ce0b2a92b906208c129f"
    sha256 cellar: :any, arm64_linux:   "d6f9d2a9ff3533206309c255eda57ce5a6cb061774c85557dd5f2936ab5adc0b"
    sha256 cellar: :any, x86_64_linux:  "a420e84ea88b741ab989c1fdfc07853aa4de0ad0c03735e81f907f16b8f0d26a"
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
