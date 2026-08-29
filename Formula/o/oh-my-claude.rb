class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.0.2.tgz"
  sha256 "29c26e8443c2f51953504585203cedb5d67806aab33eebabccf415d2a963cf5a"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "cece74ac74fcd86fea1bce98e172a289815c5dd9ff6f534618c23215757d8c2a"
    sha256 cellar: :any, arm64_sequoia: "cece74ac74fcd86fea1bce98e172a289815c5dd9ff6f534618c23215757d8c2a"
    sha256 cellar: :any, arm64_sonoma:  "cece74ac74fcd86fea1bce98e172a289815c5dd9ff6f534618c23215757d8c2a"
    sha256 cellar: :any, arm64_linux:   "984255674971688356ee919c83da17afe1486f074562b5e7d0769cd12c8a89ce"
    sha256 cellar: :any, x86_64_linux:  "ad8c0f2a48a0f4275e04cca46b03ad9a42342ee6ebfcf1aaf84c5661dbbf3c5e"
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
