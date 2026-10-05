class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.6.1.tgz"
  sha256 "8596853da38f8e3568fe160657ad43f7c5c59b8cfa8ac22e1d39656cfa8f59f8"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "15229398bb7d1574d127aaf9eb2661cd686de634f25e025d6be20c102c953981"
    sha256 cellar: :any, arm64_sequoia: "15229398bb7d1574d127aaf9eb2661cd686de634f25e025d6be20c102c953981"
    sha256 cellar: :any, arm64_linux:   "a65f2c30ec74e26c5be64d78c8b95367d4def7c048a841dad23734f9f5a09d74"
    sha256 cellar: :any, x86_64_linux:  "e4898d29a709100c5fa3c4e15392afb58a98dc61623d716ba242f9b9ba57ea53"
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
