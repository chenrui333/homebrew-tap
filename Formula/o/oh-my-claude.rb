class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.15.6.tgz"
  sha256 "c723464e0514ba5e186bfbfee3a9e1e5ef87bdb0e006c2596d85b01f242d8cad"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "7f0b45e1e05b3c7f6a02f61e022d95d49145ace1d187e468bf7825f12dc071a7"
    sha256 cellar: :any, arm64_sequoia: "7f0b45e1e05b3c7f6a02f61e022d95d49145ace1d187e468bf7825f12dc071a7"
    sha256 cellar: :any, arm64_sonoma:  "7f0b45e1e05b3c7f6a02f61e022d95d49145ace1d187e468bf7825f12dc071a7"
    sha256 cellar: :any, arm64_linux:   "4d8178b33428df882b98fbacf9935f8dce025a54c48ab41f8345ca2b456b608b"
    sha256 cellar: :any, x86_64_linux:  "0debc7911459be1a38cd97fff7e33391e664bea0850e89b80ad3610a1afbe140"
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
