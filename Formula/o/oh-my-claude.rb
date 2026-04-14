class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.11.6.tgz"
  sha256 "53b213480e26a306e7bfba9f578ae967080d499d35b35e83e152d0ada1ed661d"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b85c55807f9b0febaa22a145a70e1a29f1d51acf7f73437b3cde7cd8b6a045d6"
    sha256 cellar: :any,                 arm64_sequoia: "a8487ab19742b176da60e500ac37b4ad772ef9ad02f0d0c1e7567ed2c46672ae"
    sha256 cellar: :any,                 arm64_sonoma:  "a8487ab19742b176da60e500ac37b4ad772ef9ad02f0d0c1e7567ed2c46672ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6666579592512d0c4f4c8a27ec22f4f33344d3432a35a637c2dcafac73d03cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c1bd17aa01f1db1a8e1a3b65df06471359ab722d9ff500daeb689c2515571ed"
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
