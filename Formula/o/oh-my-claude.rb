class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.22.tgz"
  sha256 "ab58e7f965b48a152d41d647dbf683351eceb29a117229670424bec7e77aff78"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "ef8428ed5e9f6de2a99ba1295e335e3e4136b8ff637e556a58b02828d24d17d3"
    sha256 cellar: :any, arm64_sequoia: "ef8428ed5e9f6de2a99ba1295e335e3e4136b8ff637e556a58b02828d24d17d3"
    sha256 cellar: :any, arm64_linux:   "8b3ea778bfe66e7687f3ba8fb7d275a27b86af6c4611c726e9f2a5e50156839c"
    sha256 cellar: :any, x86_64_linux:  "edba4520f71ae8ca2a04048f10f9b72db450265e25e941e387abe84fd09e5f36"
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
