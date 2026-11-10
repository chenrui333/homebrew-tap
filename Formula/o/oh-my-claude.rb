class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.8.2.tgz"
  sha256 "2827efa7616742e8b9e8f3124cce4f13f26a3c6b11f77e1126cfb44f50f07ad4"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "8f4d10e115d2d74fc7aae56b60ddeb11460fe01298744ba81a412f5b7ee787c2"
    sha256 cellar: :any, arm64_sequoia: "8f4d10e115d2d74fc7aae56b60ddeb11460fe01298744ba81a412f5b7ee787c2"
    sha256 cellar: :any, arm64_linux:   "e37cd7a801c2f5ebec4d8e587cb1b3f6d659458d2dd018c58e511119a8bf9af0"
    sha256 cellar: :any, x86_64_linux:  "9902c67be0d2c1ce0954e52362440cc51d0c4692d55701cfe272697f14628406"
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
