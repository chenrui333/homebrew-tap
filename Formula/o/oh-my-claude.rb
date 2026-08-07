class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.15.8.tgz"
  sha256 "35e9b8d977697dd6bb98729fe7efbad44801737d60015fe2cda4b46063ee7b11"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "4290aa9ded9647f8fbc16e20fdb99c62ca8ce71f712a17447b32d0a693d51650"
    sha256 cellar: :any, arm64_sequoia: "4290aa9ded9647f8fbc16e20fdb99c62ca8ce71f712a17447b32d0a693d51650"
    sha256 cellar: :any, arm64_sonoma:  "4290aa9ded9647f8fbc16e20fdb99c62ca8ce71f712a17447b32d0a693d51650"
    sha256 cellar: :any, arm64_linux:   "d9b609a61265443a875285496bf4a0ce769aaa516d77505c43012ef70c19a257"
    sha256 cellar: :any, x86_64_linux:  "5c12fe4e9ad960ee4400ba67aec8a95aaf7b5cf192373e68aaa6c08de57de901"
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
