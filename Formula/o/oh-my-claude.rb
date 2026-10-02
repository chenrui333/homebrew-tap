class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.6.0.tgz"
  sha256 "ea44b8a36cdb17848b242580cb342aca37fd42b7c6e8a6d862fa2003f3453950"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "180dca99dee733379bb1be724ad63abdf400ff2e1b4e5e43b920b32f440e38c1"
    sha256 cellar: :any, arm64_sequoia: "180dca99dee733379bb1be724ad63abdf400ff2e1b4e5e43b920b32f440e38c1"
    sha256 cellar: :any, arm64_linux:   "cd6e9a466f225c425d282e26455204309bebe0c02cb500e4ed938fcfa3a71af9"
    sha256 cellar: :any, x86_64_linux:  "f94176f34390fc85d1400586097cddbba3c28707a8b3a2571b3758551269e4b2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
