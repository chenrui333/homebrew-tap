class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.2.tgz"
  sha256 "53bd4e05bf891a4257092f83f9d9a73f1557ea82b535d09c6761d57535556d7a"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "4525f0c112dc7067cfc5ac92273ab065064593f8af31c4596b7ad6a405362584"
    sha256 cellar: :any, arm64_sequoia: "4525f0c112dc7067cfc5ac92273ab065064593f8af31c4596b7ad6a405362584"
    sha256 cellar: :any, arm64_linux:   "c8652bc22c5ddb92fe295cb295deb1c8ccc718d8e50a02c568d20ce3c433bea2"
    sha256 cellar: :any, x86_64_linux:  "7d7aacc243a706efcc91fe926171e6f5f21a87a6d6ad9fc6e3d2fd0035436d6c"
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
