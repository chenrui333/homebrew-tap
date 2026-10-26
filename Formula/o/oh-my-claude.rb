class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.14.tgz"
  sha256 "374aab17317b62c115d5bcb0fa507714fc47cbd35ca8410d3dd4f81f5bf8f45c"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "92ebda5c5e8c4f883c56c07bb990bba6ebf6b12cf06d835f9ec83d61370027a3"
    sha256 cellar: :any, arm64_sequoia: "92ebda5c5e8c4f883c56c07bb990bba6ebf6b12cf06d835f9ec83d61370027a3"
    sha256 cellar: :any, arm64_linux:   "670961692cd020a33e609c0c8a126a9478e8d2c43478f1f9b07302786d292dc2"
    sha256 cellar: :any, x86_64_linux:  "43581e2a78af7eeaa9b9dfe0890f89faba131dd50daa5d491680c934621b06d0"
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
