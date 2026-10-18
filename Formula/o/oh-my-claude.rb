class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.4.tgz"
  sha256 "64db986d195a6a7de804f2bc8a957a56fd9af5bb9ff219a2f2d9f5c6594349df"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "c682b7d4932c124d42c784601ecfe10f7d77847fe4d9b7cbbd5c208b8e33e180"
    sha256 cellar: :any, arm64_sequoia: "c682b7d4932c124d42c784601ecfe10f7d77847fe4d9b7cbbd5c208b8e33e180"
    sha256 cellar: :any, arm64_linux:   "f3ff5e817251e5e5577a19bf5dc9a6b0bc41073550067959a4d913a12b844b8b"
    sha256 cellar: :any, x86_64_linux:  "c34c0de21caaff0b9a5d5b08aa9d3d0cc7c1de32fa8851819a50607a4a26f3e6"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove vendored prebuilt ripgrep binaries that cause Mach-O relocation failures
    vendor_dir = libexec/"lib/node_modules/oh-my-claude-sisyphus/node_modules" \
                         "/@anthropic-ai/claude-agent-sdk/vendor"
    rm_r(vendor_dir) if vendor_dir.exist?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omc --version")

    output = shell_output("#{bin}/omc test-prompt 'Format a JSON record.'")
    assert_match "Enhanced prompt:\nFormat a JSON record.", output
  end
end
