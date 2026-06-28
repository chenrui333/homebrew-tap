class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.15.1.tgz"
  sha256 "7acdd7a9263a4cc587a8353b9f822b0711e4c464845b886d5763f37a5e20b13b"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "e5bc4903d72698bfc77e96e02d0e5fc385687cf8ea34dc36c5d0cdb5311b8909"
    sha256 cellar: :any, arm64_sequoia: "a7c0aac044b96be146a4f3da7d01076b1ed25fe1a32c6f037e137968c3eb373b"
    sha256 cellar: :any, arm64_sonoma:  "a7c0aac044b96be146a4f3da7d01076b1ed25fe1a32c6f037e137968c3eb373b"
    sha256 cellar: :any, arm64_linux:   "1f399c5db0e98c8127b47a9792a2d242189d82cb176cd229c2a2cd51a90b4d28"
    sha256 cellar: :any, x86_64_linux:  "b8aa80be27a7a0a72c8e283a698aa6c0a396b1b1c745a993c7c5e2d5a49dc969"
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
