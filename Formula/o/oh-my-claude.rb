class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.14.5.tgz"
  sha256 "f3a36802920b712bb21e8593c225677b3f00fd4048b1b83a686e0645a8322639"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "7f91c1eebb407ea5d40b86a028131a96341b9100c598586eb30f0d70bd594e17"
    sha256 cellar: :any,                 arm64_sequoia: "525e087899d9e204eacbfc4aa3d12fb7cc4bcd873a5e075ca77a24d322ed6a6f"
    sha256 cellar: :any,                 arm64_sonoma:  "525e087899d9e204eacbfc4aa3d12fb7cc4bcd873a5e075ca77a24d322ed6a6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "953ad233aa0d09ef2e06d2c91ca6268ad3fca0d6b90ec148c3a336a44f33927f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e853d40b3300907e112c6ee04ca2553c0e179dde2b62ec3abb06ebf7c3e20180"
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
