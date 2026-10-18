class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.4.tgz"
  sha256 "64db986d195a6a7de804f2bc8a957a56fd9af5bb9ff219a2f2d9f5c6594349df"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "9be1b2ec334e684997dcbb28db20ecc7a1a1e7c8b806ca59ed12756c3f246e12"
    sha256 cellar: :any, arm64_sequoia: "9be1b2ec334e684997dcbb28db20ecc7a1a1e7c8b806ca59ed12756c3f246e12"
    sha256 cellar: :any, arm64_linux:   "9f423a8ce5d9bd2515959ea7e52848e2339843aafa5270c7a00b483d018e20ef"
    sha256 cellar: :any, x86_64_linux:  "50fb2933062f9f00e5c80ac034eab9f068c7bf41b708e1dbc668175d514f90da"
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
