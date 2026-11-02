class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.25.tgz"
  sha256 "d423f186d451417aa42f757704b1420c144e45161dcee72c5529764a29a3536c"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "8ef78a89f540dd0ab68faf630f44197b9eeab7bf7864b530863cb20b1460b574"
    sha256 cellar: :any, arm64_sequoia: "8ef78a89f540dd0ab68faf630f44197b9eeab7bf7864b530863cb20b1460b574"
    sha256 cellar: :any, arm64_linux:   "97973b026d1c4823077ec531dd49a56d823ca52635a86062daaf965ce3a33f92"
    sha256 cellar: :any, x86_64_linux:  "29ad23dc45d94c2e24333dd606ba1f46437b0b94b86bf56f8b2ff13e778cc170"
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
