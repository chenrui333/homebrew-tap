class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.14.tgz"
  sha256 "374aab17317b62c115d5bcb0fa507714fc47cbd35ca8410d3dd4f81f5bf8f45c"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "b3191e5edc75cff94391fae23e1730c15d9220d845687895fc5db4582e228d40"
    sha256 cellar: :any, arm64_sequoia: "b3191e5edc75cff94391fae23e1730c15d9220d845687895fc5db4582e228d40"
    sha256 cellar: :any, arm64_linux:   "cd35a0e0314a2171a17872ebaabc65672581efeab22b6a6826086a9bdfa503a8"
    sha256 cellar: :any, x86_64_linux:  "c32dce7b7394fa0a9acab20cb58f2afc123296b42396d32f19ed5a249aba47c4"
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
