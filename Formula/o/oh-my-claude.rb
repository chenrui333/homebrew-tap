class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.18.tgz"
  sha256 "a0ee474128b45a5d25f34184bc70ff972b4cd1276696e184cd63ce4e2a017dfd"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "6b8ddf437ab45a618336a54911ad35aa4c7158c0d03edc00690d2e465e6e0baa"
    sha256 cellar: :any, arm64_sequoia: "6b8ddf437ab45a618336a54911ad35aa4c7158c0d03edc00690d2e465e6e0baa"
    sha256 cellar: :any, arm64_linux:   "1d3ee73dc36cfb78a1a8db4dd5a65ab361882def34855f1eea48cc92ffabc1ba"
    sha256 cellar: :any, x86_64_linux:  "302f9f198f6549b8d1893f532ec8146f004d669b55f01d339da72783192a19d1"
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
