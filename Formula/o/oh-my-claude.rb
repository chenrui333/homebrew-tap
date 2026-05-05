class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.13.6.tgz"
  sha256 "c6705fc9461ba030becc51ad648d3c6100ab4fe8c2edbd8bb301fe24469b03d7"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "fd6962f29a0f437ba9ff260b4e04c21ae6b7b20469f18ce5704cc0efa286572c"
    sha256 cellar: :any,                 arm64_sequoia: "66b8985c92c40a6787c69c52370c3d3610d248e2dc31404b332f7796ab66e48f"
    sha256 cellar: :any,                 arm64_sonoma:  "66b8985c92c40a6787c69c52370c3d3610d248e2dc31404b332f7796ab66e48f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d21fde6ec327b435961387102ce8860afcc932faf13ab1dabd0e1db1908bdebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca3afa1d0605309d536a7fb6313f90be3ee38d82b50de03280a4c240e28cd66e"
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
    pkg = libexec/"lib/node_modules/oh-my-claude-sisyphus/package.json"
    assert_match version.to_s, shell_output("node -p \"require('#{pkg}').version\"").strip

    output = shell_output("#{bin}/omc --help 2>&1")
    assert_match "omc", output
  end
end
