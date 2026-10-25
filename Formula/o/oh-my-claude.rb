class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.13.tgz"
  sha256 "e52b5d14b2e350d7d7bcf9f7b8e13cc20a4833804a8221a146270d9361d5d195"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "69b05c5939165d6b32cd50f5eb77deed8e6073670ead0a094cdd900e706288a2"
    sha256 cellar: :any, arm64_sequoia: "69b05c5939165d6b32cd50f5eb77deed8e6073670ead0a094cdd900e706288a2"
    sha256 cellar: :any, arm64_linux:   "33c37943aeee8064703baeacf83d928d1463cdc86592f81eadd1d9df7ec66264"
    sha256 cellar: :any, x86_64_linux:  "11864411ed8a42e18cd13764458370856e6ab987c88c6a09342f5773356f6ee0"
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
