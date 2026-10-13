class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.0.tgz"
  sha256 "dfaef994c1ec1641270d6356f697aaa8f64bea03998820ce6e46056a985c6b06"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "63c0069d8a395f1fabd7904c6291cd586f21bdbbe3b47d141ae005e0e66c5660"
    sha256 cellar: :any, arm64_sequoia: "63c0069d8a395f1fabd7904c6291cd586f21bdbbe3b47d141ae005e0e66c5660"
    sha256 cellar: :any, arm64_linux:   "6b4ed466c16c5453cce02f10bbd6393b347538082ee78d0e68b6384e7176cfbe"
    sha256 cellar: :any, x86_64_linux:  "d24a01cfdd6d6bca845a47f596005e841474056ca8f11224701fa74b454a2f4a"
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
