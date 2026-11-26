class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.8.8.tgz"
  sha256 "fc06c195d66d04586ba4bfc43146216fa6f093930d053f647e4f40cd510993f1"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "f94a16427f9adf5bee0bfa6f47f170eb4da00034e42702434d60b679bd8cf57a"
    sha256 cellar: :any, arm64_tahoe:   "e4e2e532a45b2c6fb8f475ae4895b9e59413f7b9c06e2a5a117f94c11f786369"
    sha256 cellar: :any, arm64_sequoia: "e4e2e532a45b2c6fb8f475ae4895b9e59413f7b9c06e2a5a117f94c11f786369"
    sha256 cellar: :any, arm64_linux:   "2cdd86881488b28bc6dbef34fb511ac4bde72a36cd86504744bf96a34f3e0711"
    sha256 cellar: :any, x86_64_linux:  "8bef6702a629a6673684961c3789a19e917838c65c421cd9d49d93221c0ff20c"
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
