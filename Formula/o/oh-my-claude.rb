class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.6.1.tgz"
  sha256 "8596853da38f8e3568fe160657ad43f7c5c59b8cfa8ac22e1d39656cfa8f59f8"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "cfceaa33257c3c41b45cff23b04d2e28e049cfe7ffae04015a839250438dcd05"
    sha256 cellar: :any, arm64_sequoia: "cfceaa33257c3c41b45cff23b04d2e28e049cfe7ffae04015a839250438dcd05"
    sha256 cellar: :any, arm64_linux:   "e6e8d5540c566369a65a974e833dc7993d4fe323c9e23eb5610d711e7903a4b9"
    sha256 cellar: :any, x86_64_linux:  "526ff5b76f16ea6eb95a1b7a398ec5d597c582fee0ce22bfcd213cbc4c4e5493"
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
