class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.15.10.tgz"
  sha256 "0e8acf20947a1274a61bc87ffebf8702f1a8fea570eda649db09c960c804ae8e"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "47728969db6409ee60e02af037ea1f325376cbd3301781c72c9eb2a511e48d9b"
    sha256 cellar: :any, arm64_sequoia: "47728969db6409ee60e02af037ea1f325376cbd3301781c72c9eb2a511e48d9b"
    sha256 cellar: :any, arm64_sonoma:  "47728969db6409ee60e02af037ea1f325376cbd3301781c72c9eb2a511e48d9b"
    sha256 cellar: :any, arm64_linux:   "bf68235b85f0e1039c931c239d1de30b4a4679324cc5c2b2e7c65b6062c54afd"
    sha256 cellar: :any, x86_64_linux:  "5a57629dafdd9953342c242a2def7f4923253bdef1bf56eaab993389ba522dc8"
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
