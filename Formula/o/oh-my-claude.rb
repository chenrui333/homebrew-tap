class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.0.1.tgz"
  sha256 "f196cf7561df87b49af2e0916753eef7a6cbf4c0e8b55073f67d5b93d50171f1"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "256d8ff24b938918ef0bbe435ab6ee57ac3b5b9b9ee4f817c29213bc7d516db9"
    sha256 cellar: :any, arm64_sequoia: "256d8ff24b938918ef0bbe435ab6ee57ac3b5b9b9ee4f817c29213bc7d516db9"
    sha256 cellar: :any, arm64_sonoma:  "256d8ff24b938918ef0bbe435ab6ee57ac3b5b9b9ee4f817c29213bc7d516db9"
    sha256 cellar: :any, arm64_linux:   "a64a5fe9778f9727baccb5a3fa3e9f8872031b2f66b5b51bc0e522e09a9cb131"
    sha256 cellar: :any, x86_64_linux:  "a0d7fede56208d1e72af96f40b38d3f2c675f6dcc2a7bd31aac6db84d0e99ecf"
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
