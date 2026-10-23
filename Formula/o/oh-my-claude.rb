class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.8.tgz"
  sha256 "50fe1dd24df2fbceb3a1469c7f466c309cb12009d0108b6b436054c157bacae8"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "9866b56e44b74bfe5d1036cf208818a35bc8534a41bd0c4d319dd04254bb9b2c"
    sha256 cellar: :any, arm64_sequoia: "9866b56e44b74bfe5d1036cf208818a35bc8534a41bd0c4d319dd04254bb9b2c"
    sha256 cellar: :any, arm64_linux:   "4c176e1ba247543ebe9ef14dfe40c855803e25d0ab27711f953b3402b55fd2b1"
    sha256 cellar: :any, x86_64_linux:  "4d30d2864767b807e88ad9b6d46d29dfebedc8b514e1e799ce8eb1a45b8d3fd4"
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
