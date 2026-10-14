class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.1.tgz"
  sha256 "bb5af7e6353388248f51a6344c8308aec1ca85944294571d60e7ab2aa0baba98"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "641c5787462bdcdff488009013c52d5a722641afe88d644105074ea1b5de083d"
    sha256 cellar: :any, arm64_sequoia: "641c5787462bdcdff488009013c52d5a722641afe88d644105074ea1b5de083d"
    sha256 cellar: :any, arm64_linux:   "c6bf2cf52609196ec967a2dcca1a86ca777855ceca2d2fade3c6ce5ec28b83a0"
    sha256 cellar: :any, x86_64_linux:  "82c4c8865537eac29de821130c4afb17f0d1ebf4ec1247442ab39eb7d170680b"
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
