class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.15.1.tgz"
  sha256 "7acdd7a9263a4cc587a8353b9f822b0711e4c464845b886d5763f37a5e20b13b"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "a77aeac8f787f8673684f585df1227adee01b18c18da6eb84b868cb5ddfb3ab5"
    sha256 cellar: :any, arm64_sequoia: "30e47b113c79ad0136dd4a1486a610ebe2d89031b5358f5bf373cbe7d7594fbe"
    sha256 cellar: :any, arm64_sonoma:  "30e47b113c79ad0136dd4a1486a610ebe2d89031b5358f5bf373cbe7d7594fbe"
    sha256 cellar: :any, arm64_linux:   "2edaa900198ffd80880e548259434382c60ad9120e62be9a8a4599e1814767f4"
    sha256 cellar: :any, x86_64_linux:  "8b21f78a6caa236f05982c12fcfa6f784b28a44fe77f4a3a418ce2332cedd03e"
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
