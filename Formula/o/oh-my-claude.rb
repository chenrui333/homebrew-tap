class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.14.7.tgz"
  sha256 "51356dcdd79d58cdd867b87f265fa76b338f5d0ca0b44c868adf825536b519df"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "cf9f6be3a74794e4c16fc961df0e72bb4d201728577d61edc540d9ffc1e80afe"
    sha256 cellar: :any, arm64_sequoia: "df5348d70179333b61531b7be00e929bf7a6c6a98e67dbbbac2df4800e271e0b"
    sha256 cellar: :any, arm64_sonoma:  "df5348d70179333b61531b7be00e929bf7a6c6a98e67dbbbac2df4800e271e0b"
    sha256 cellar: :any, arm64_linux:   "90b83bcaafd8ea77195ad3678e1e533f52c94150f433908a1610ec6588fde40f"
    sha256 cellar: :any, x86_64_linux:  "cc122408d6c2788d0bb9b83efb5f70ebc6bb0fc3d5e08a946fb07cbf972bdff7"
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
