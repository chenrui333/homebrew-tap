class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.1.0.tgz"
  sha256 "497b2bd5675d3b5580bda68b2b938ecadcd63963c901ee2cdcb0b4d1b33978e4"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "b89aafdf1fed654e977ddfbc6c38e54db459549c8af0a3dfe5418fda92b048af"
    sha256 cellar: :any, arm64_sequoia: "b89aafdf1fed654e977ddfbc6c38e54db459549c8af0a3dfe5418fda92b048af"
    sha256 cellar: :any, arm64_sonoma:  "b89aafdf1fed654e977ddfbc6c38e54db459549c8af0a3dfe5418fda92b048af"
    sha256 cellar: :any, arm64_linux:   "4c9aea98b455c44c547a995b70812fac6240face1b8012778870c25b341e1eeb"
    sha256 cellar: :any, x86_64_linux:  "d83e2e190189d649367fb24447f3baa6f7ea8e2fb4cf0e1247a374c33d8a1f48"
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
