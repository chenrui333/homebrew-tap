class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.13.5.tgz"
  sha256 "6a7629aec2f9ce84bd4be2b15b8b87162ce0031950aa01382b20b10db66ea5d9"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e9ba4e54824c6f0ec83a4d314b092f69eb54debd37d92eb947d6431fbd8e5daf"
    sha256 cellar: :any,                 arm64_sequoia: "b660253b1d27e5617db5ac5f2654f5a4667c4cc3abbed82b6e884de8d5a1ea50"
    sha256 cellar: :any,                 arm64_sonoma:  "b660253b1d27e5617db5ac5f2654f5a4667c4cc3abbed82b6e884de8d5a1ea50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1da0af9036e749c7dd250e68300d8d84054a16eb4480a3b1792e1186dfb57cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c79df1989aca9ed6c71e2b54c993cc0f8782a2fb90a08f2386424b0ce2210756"
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
