class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.9.tgz"
  sha256 "830f77798769ff369df615b2fcd4651182d329f2639ebf3481de48a22447f0e0"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "f58aa9cc5612ea4e0aa35411832c1c15aaac927857ba3420d9ca88058f452bec"
    sha256 cellar: :any, arm64_sequoia: "f58aa9cc5612ea4e0aa35411832c1c15aaac927857ba3420d9ca88058f452bec"
    sha256 cellar: :any, arm64_linux:   "9addd339362cd309cb2b9a38d4b0d97617090a87607b4db877b01c1105d3ffc0"
    sha256 cellar: :any, x86_64_linux:  "9137321d74ad38fcc9f999578234ddec22a10de85b109d21c2daad3f07e5bd50"
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
