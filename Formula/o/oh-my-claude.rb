class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.6.2.tgz"
  sha256 "a5bdab07adba9d3e21d5ff980afcb001c20822a5683644d1eb70b6073a3025d2"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "44bc5ba6ce9ff281c0665548cf9d43330ad6288aec04cc713a1c8b13035fe31b"
    sha256 cellar: :any, arm64_sequoia: "44bc5ba6ce9ff281c0665548cf9d43330ad6288aec04cc713a1c8b13035fe31b"
    sha256 cellar: :any, arm64_linux:   "97c7524e7728e2b1144e3e434a7f97b97b4812916d0f019d89aa173354bbe5e9"
    sha256 cellar: :any, x86_64_linux:  "606f17b44b4d9c17080a9bbf8a6c4f8cfbc1ca4a120d4cd41943c87e692ecbb3"
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
