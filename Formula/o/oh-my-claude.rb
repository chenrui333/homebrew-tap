class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.14.7.tgz"
  sha256 "51356dcdd79d58cdd867b87f265fa76b338f5d0ca0b44c868adf825536b519df"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "0b020293efb02191101fbd0259c88caefcebf5430aacf366266a66a6e878685e"
    sha256 cellar: :any, arm64_sequoia: "8e33d1168effbe48ead1d3e117e44c4df56a992ec57c07078f9b27e89b6691a8"
    sha256 cellar: :any, arm64_sonoma:  "8e33d1168effbe48ead1d3e117e44c4df56a992ec57c07078f9b27e89b6691a8"
    sha256 cellar: :any, arm64_linux:   "ce485fd9ca603f3cdc7e2a50819ad267948e2c3ddfbb76e709d42becaab2120f"
    sha256 cellar: :any, x86_64_linux:  "59cba853d1e229d7c4d4c84f71ffa7bf05b984aa04dcb92b07527767e5b2df6f"
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
