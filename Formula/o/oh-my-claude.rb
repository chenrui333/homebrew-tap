class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.11.5.tgz"
  sha256 "a078d52dc82f9050a43ee073420be8aba87b12eac21055e10945d8294b726847"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1574b5f4a30cba6080a5a7d1cd663642dae19f34f7c1f09816d5674f3c233b30"
    sha256 cellar: :any,                 arm64_sequoia: "a7072c7e839ad6300f88fea89bc7f8f8e11bca4bed47686c517cc52e3ef5eff9"
    sha256 cellar: :any,                 arm64_sonoma:  "a7072c7e839ad6300f88fea89bc7f8f8e11bca4bed47686c517cc52e3ef5eff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae6a49e2fa75b43342ddda3c4b5b0a139eb888178af0613930d8bcb5afe9653a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "999ff627c8f306bce58480582eb3c84df8547483afe8fa24b03060aad4d9746b"
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
