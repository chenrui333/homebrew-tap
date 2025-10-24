class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.7.2.tgz"
  sha256 "830ce89a5c6863cd8712f83b26b9924485789fdc3a8359a6ef2872cfe85981a7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c50c82073ce2cdf774a055b54a32753b123c69f082df69763018eb4962005ea3"
    sha256 cellar: :any,                 arm64_sequoia: "67d0cecbf1f4e9246c208caab35036975aad5ca1ca856bfe3990a74f4cdf2970"
    sha256 cellar: :any,                 arm64_sonoma:  "67d0cecbf1f4e9246c208caab35036975aad5ca1ca856bfe3990a74f4cdf2970"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "640d69662d9579ed7e75fc6a9e8f634da382f6164eb99a232cd1ad6a2825035e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "269a164cde866c6c1bd708b0c4ccc3e628845fa4541e1720e3d7f643f50562ba"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    ripgrep_vendor_dir = libexec/"lib/node_modules/vibe-log-cli/node_modules/@anthropic-ai/claude-code/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibe-log --version")
    assert_match "Failed to send sessions", shell_output("#{bin}/vibe-log send --silent 2>&1")
  end
end
