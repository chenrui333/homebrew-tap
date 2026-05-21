class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.14.1.tgz"
  sha256 "856ae67059c05f7b78b27baf434343f0fce9487887bc48fba02b207b91fa216d"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "0c060febabc8265f4cad2b01966f61320c2e0619a845e94709b2fd5fd7b5344e"
    sha256 cellar: :any,                 arm64_sequoia: "467a5c4322e891cbce60d44d14c01358eb7a82d8630884e9b99cccd071c8ed44"
    sha256 cellar: :any,                 arm64_sonoma:  "467a5c4322e891cbce60d44d14c01358eb7a82d8630884e9b99cccd071c8ed44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2762c9864662548e8e15ae052801c0e0134975e76cd7e7290fc4d9a22f2c1ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16c23d873a6573e4e35fea1ae6ccf5de72cb533217da21527f28814a07748bfb"
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

    output = shell_output("#{bin}/omc --help 2>&1")
    assert_match "omc", output
  end
end
