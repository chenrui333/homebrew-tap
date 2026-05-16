class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.14.0.tgz"
  sha256 "3a2b7cf4b374861599c0e2e232a7b7e2596c023c0ffda9beabfcd9ae825cdc1d"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "83ac11bdc9d61969161fc2b6cee480739af51b339e8cd472bbde36e282ff2513"
    sha256 cellar: :any,                 arm64_sequoia: "e6a1cb7f7257073d878c32380e76b7070e9d383da6210658a3b2916c7f7a52ad"
    sha256 cellar: :any,                 arm64_sonoma:  "e6a1cb7f7257073d878c32380e76b7070e9d383da6210658a3b2916c7f7a52ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96c1f1d30ea11040efeb7406d73121ec8e67d6101790ea37e761e132f862160f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d68268f6ea7e7f000fe25861e81fdbe06ecaf2c6172d559c8c7657b1f6b6a25f"
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
