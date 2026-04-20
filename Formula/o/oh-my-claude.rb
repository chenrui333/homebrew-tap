class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.13.0.tgz"
  sha256 "fae627c9ca0424be59526fe7d87840abb9730cf633f1934e717ee8c762103566"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6252cd328233a1e3c7c54a64f6ae7873aba39ecbff74bb35ba226fdfd924b322"
    sha256 cellar: :any,                 arm64_sequoia: "12e52f00693567d6b76fb01a1e09618a18107ec770dc1c0e4bf7d86ac3bdc49d"
    sha256 cellar: :any,                 arm64_sonoma:  "12e52f00693567d6b76fb01a1e09618a18107ec770dc1c0e4bf7d86ac3bdc49d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "523015fd18c46a15ca5e113fa86dffb47f643cd201f6094e43498849d14e91e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8937e677f46009b5ac3ee02ed270995bdb0866add7cc5bca613b37c28339000b"
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
