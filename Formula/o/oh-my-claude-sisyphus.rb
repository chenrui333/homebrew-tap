class OhMyClaudeSisyphus < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.9.3.tgz"
  sha256 "0d62ea8124c4d6fb371571c53029cfdabdfaa0b5eb81e1a558e4638c629da760"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "58c29f96a04e548223d97254ab01e9b933632a0118313621cb3b14fd033ca4c7"
    sha256 cellar: :any,                 arm64_sequoia: "efb789c82ba5ce093f7ac01995b9885707e739becff2f453d29a1cd920c2a566"
    sha256 cellar: :any,                 arm64_sonoma:  "efb789c82ba5ce093f7ac01995b9885707e739becff2f453d29a1cd920c2a566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d0664ee7550343b0a06d93c6515fe26bbf30accb0e769b3620d27d577196a2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b78f32c62194e3d46d36e1ff8ed1320f94297f7176165bdf0e3cb66f61e50b16"
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
