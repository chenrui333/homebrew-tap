class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.8.7.tgz"
  sha256 "ea781382efd3311bc0f439c3899432be154fc1dc894004449615bc6bf2f320e6"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "1c0b35e864c60e35cef00d6393ffc6382022300f25afafcb23c368d6a14e2f22"
    sha256 cellar: :any, arm64_tahoe:   "24490c153d920856ba405920d6f5c909dbe7435b80739af6ffd37310d2bc864c"
    sha256 cellar: :any, arm64_sequoia: "24490c153d920856ba405920d6f5c909dbe7435b80739af6ffd37310d2bc864c"
    sha256 cellar: :any, arm64_linux:   "057cd37990457f1857b69a38be4b7a2de941e1a141626ac8d1d166c20ad9bc06"
    sha256 cellar: :any, x86_64_linux:  "edd47b4bc55b4f75dac0444dada5f013fc7205f8b54cb078fa41ebf47df83576"
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
