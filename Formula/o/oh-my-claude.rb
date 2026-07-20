class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.15.6.tgz"
  sha256 "c723464e0514ba5e186bfbfee3a9e1e5ef87bdb0e006c2596d85b01f242d8cad"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "8710464a36fa24bcf37681a2857ba1f0f514c168c0ed9a6f25eb8f1292e9f95e"
    sha256 cellar: :any, arm64_sequoia: "8710464a36fa24bcf37681a2857ba1f0f514c168c0ed9a6f25eb8f1292e9f95e"
    sha256 cellar: :any, arm64_sonoma:  "8710464a36fa24bcf37681a2857ba1f0f514c168c0ed9a6f25eb8f1292e9f95e"
    sha256 cellar: :any, arm64_linux:   "2a6631781435b0e65fd98ae4214b3827bbdf1fa16497a979294aed926ead5970"
    sha256 cellar: :any, x86_64_linux:  "ef6c3eb286ec8c9d7de8ddc636eb9721346fe27ac943946b371fe600844f1605"
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
