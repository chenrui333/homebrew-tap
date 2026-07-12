class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.15.3.tgz"
  sha256 "f15c378de390d67708237d07321b7219115f6ec0ca4ff38be891e801dc88395f"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "619f3daa138b5020750f5b9b32b981a38eafc56b756729ea3d6640b8bfc0b576"
    sha256 cellar: :any, arm64_sequoia: "ad1294b69289a128a56bc107a93b9c063befc0206dba97bf14821177731fdb5e"
    sha256 cellar: :any, arm64_sonoma:  "ad1294b69289a128a56bc107a93b9c063befc0206dba97bf14821177731fdb5e"
    sha256 cellar: :any, arm64_linux:   "5de743b9844bb88e14bc28da84ff20ca0e24b4a5557498a7be754435d12e500b"
    sha256 cellar: :any, x86_64_linux:  "37e37b38c15dfeb82aec5c61491323180a1aa2efb10ba9d42394244569928041"
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
