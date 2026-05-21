class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.14.1.tgz"
  sha256 "856ae67059c05f7b78b27baf434343f0fce9487887bc48fba02b207b91fa216d"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "4f80fb95dc64359170a1b0d8c67e4466ac21275af16e7d0db38ffc13f6e5e3c4"
    sha256 cellar: :any,                 arm64_sequoia: "933012c7c0d5ed5d2abc0d728c25e8b1426e5ebd15c97f6b97ceafc9c4a263ca"
    sha256 cellar: :any,                 arm64_sonoma:  "933012c7c0d5ed5d2abc0d728c25e8b1426e5ebd15c97f6b97ceafc9c4a263ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "968fb6712b24ef8a7e0bc5a3ad419caf9f98be102243ce3e5970ea4056affd83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dc8c6102979366bf1e23170f38692cc34b8dde62cce7b99d2ceacf7ca002d0b"
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
