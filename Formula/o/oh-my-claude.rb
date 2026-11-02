class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.25.tgz"
  sha256 "d423f186d451417aa42f757704b1420c144e45161dcee72c5529764a29a3536c"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "ff8e364f9323ba37cda18b20b4235440132b22e704243eb054d74cf4e115a5e1"
    sha256 cellar: :any, arm64_sequoia: "ff8e364f9323ba37cda18b20b4235440132b22e704243eb054d74cf4e115a5e1"
    sha256 cellar: :any, arm64_linux:   "bb9608c1a9a341096b29dd812cd69bb1159b0291b503117b40ad0e420a5f9ab0"
    sha256 cellar: :any, x86_64_linux:  "e92bdeefa805e39532792936528ee1ceb57aa6e08cc0d0cd0c5575b7bb1701a4"
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
