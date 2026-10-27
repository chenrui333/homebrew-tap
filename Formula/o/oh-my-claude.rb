class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.7.16.tgz"
  sha256 "2957534030c4630dc26c49b1524c6815986daf728ebb87bfbe2297368257502d"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "9f2196e7978b3b9b1b62cda96914e253a0419fd991e692f9909925d437fc98e0"
    sha256 cellar: :any, arm64_sequoia: "9f2196e7978b3b9b1b62cda96914e253a0419fd991e692f9909925d437fc98e0"
    sha256 cellar: :any, arm64_linux:   "50e534f07d4338a146833f4fc961ff04b03d51e360907e4d2eaabacea2bb13a4"
    sha256 cellar: :any, x86_64_linux:  "263fff12a8aeaa85760a77992db127d92398eba39a439c5aa2bc0ade8fc3141b"
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
