class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.14.5.tgz"
  sha256 "f3a36802920b712bb21e8593c225677b3f00fd4048b1b83a686e0645a8322639"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "dc17c79c33785dbaf79262afbc4c4836e4689ceba9d51191c4581ee7f1e73e5e"
    sha256 cellar: :any, arm64_sequoia: "199b8832d17734b4567be000ae2862ec92b3ed3c6ea2d8dd84091b0c7bffa5f7"
    sha256 cellar: :any, arm64_sonoma:  "199b8832d17734b4567be000ae2862ec92b3ed3c6ea2d8dd84091b0c7bffa5f7"
    sha256 cellar: :any, arm64_linux:   "f66a600894b8097ce81da1815a3d4ce873e9d704c7fc20466f4e5cc169bb6086"
    sha256 cellar: :any, x86_64_linux:  "fa291ba7fad899a39e81930977134527ff66020837fd1e543fce19e024a03649"
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
