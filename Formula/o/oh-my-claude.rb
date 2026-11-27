class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-5.8.9.tgz"
  sha256 "c58da8c814b99b4d970616bc13e0a316b61aed9dc0d3d4fff05160b7c6af6afb"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "dc6be4ba7b540222b632fa59930412c24cdc354aa47834b9746449ff89078f86"
    sha256 cellar: :any, arm64_tahoe:   "b7cc6a91fc0a88ccae3ecc3571b0470c230dda1718d9e4cf919605511d188cd9"
    sha256 cellar: :any, arm64_sequoia: "b7cc6a91fc0a88ccae3ecc3571b0470c230dda1718d9e4cf919605511d188cd9"
    sha256 cellar: :any, arm64_linux:   "6cc3804d9ef2cbd38504aa649e9b6179dc99bee573230f1c65595a6ddf87aee1"
    sha256 cellar: :any, x86_64_linux:  "294788f47928b41b5333c25c1ac82a6adfddb1d4ce73d67ecad24572758a70f0"
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
