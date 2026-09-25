class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.5.0.tgz"
  sha256 "339ddb717c14f009947d65e2b47929e23b602e88ea5e7da954146bdb986f58ae"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "0133d615384b64db184200026a2d555241bb6561601e8858f2de12730d9b4240"
    sha256 cellar: :any, arm64_sequoia: "0133d615384b64db184200026a2d555241bb6561601e8858f2de12730d9b4240"
    sha256 cellar: :any, arm64_linux:   "b4500d4b6c504f9fbef701a011797ca69f47ec3825fbb708263ef09a9dfdebd4"
    sha256 cellar: :any, x86_64_linux:  "239756adfe6711ccdf5e7a3cc6df072ca3513715d8d4778a9ecc161d986c826b"
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
    assert_match version.to_s, shell_output("#{bin}/omc --version")

    output = shell_output("#{bin}/omc test-prompt 'Format a JSON record.'")
    assert_match "Enhanced prompt:\nFormat a JSON record.", output
  end
end
