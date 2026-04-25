class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.13.4.tgz"
  sha256 "1db582e77924b0a6d87cb61fe01505f78464940ba39a992196956115429f46b4"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "0f6b97acdf3bcec614dfbd71bde5557e0651d0d88a07e2bc2862884da085646a"
    sha256 cellar: :any,                 arm64_sequoia: "9ab02fbe85018bb2e21a7da15b52a691f0e3e1d61b9ee193583ea7159c44b126"
    sha256 cellar: :any,                 arm64_sonoma:  "9ab02fbe85018bb2e21a7da15b52a691f0e3e1d61b9ee193583ea7159c44b126"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b25c336a7b7cd3504e482b6f672cb79c5f0c9f44e1f1687ee5e5065e5173d4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96d49367f18be5f2600d9b82e6bf7390f5141a9d23b2255b5757b6816182a6b2"
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
