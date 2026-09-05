class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.2.0.tgz"
  sha256 "dd7ad5674b2a9d160e8a20ab448605eb5f45cf1b590b01af0d475b1f87bd8f97"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "d272f5991dcbbcf56944c1e3e9883cd6c60021872cd5da9814c41e5bfe15442c"
    sha256 cellar: :any, arm64_sequoia: "d272f5991dcbbcf56944c1e3e9883cd6c60021872cd5da9814c41e5bfe15442c"
    sha256 cellar: :any, arm64_sonoma:  "d272f5991dcbbcf56944c1e3e9883cd6c60021872cd5da9814c41e5bfe15442c"
    sha256 cellar: :any, arm64_linux:   "a1bcf3ca52f625f9320022bb340193d659494381e8b1c55a97da24be218df45a"
    sha256 cellar: :any, x86_64_linux:  "9e8a2028493cc1dcb715df022e6b541d144e547656ac360f48b7d1894194e0dd"
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
