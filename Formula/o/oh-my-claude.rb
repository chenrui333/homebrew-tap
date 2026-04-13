class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.11.5.tgz"
  sha256 "a078d52dc82f9050a43ee073420be8aba87b12eac21055e10945d8294b726847"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ef990665ec94a538c5c58a0304288903d1259ea610071557e9eac98ca635538a"
    sha256 cellar: :any,                 arm64_sequoia: "468641daf736dffa5186f445df5df7072c0f9f28f091e4e997148f6d00158122"
    sha256 cellar: :any,                 arm64_sonoma:  "468641daf736dffa5186f445df5df7072c0f9f28f091e4e997148f6d00158122"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57e7b2d0dec9c517efa077765e48955c0313e43ea8b8477d82184abb59ac0c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c0f09840bbefd1473b537e5f4ffa847ad6045378db0eccf238eac5f74ffc8c5"
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
