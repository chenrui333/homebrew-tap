class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.15.2.tgz"
  sha256 "3d0b2fecd88747726f723648a0f7c500cacc798bd1edf92d82f2da368745bfaa"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a47748aa5391f3f2e0b262bf54ca7239663d95f365670895bd4c8fc220fd5f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a47748aa5391f3f2e0b262bf54ca7239663d95f365670895bd4c8fc220fd5f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a47748aa5391f3f2e0b262bf54ca7239663d95f365670895bd4c8fc220fd5f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b87ea47d0831e73cf7be7b0dedf58569918c649030922cf2c95163a2656586c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b87ea47d0831e73cf7be7b0dedf58569918c649030922cf2c95163a2656586c6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    pkg = libexec/"lib/node_modules/oh-my-codex/package.json"
    assert_match version.to_s, shell_output("node -p \"require('#{pkg}').version\"").strip

    assert_match "oh-my-codex", shell_output("#{bin}/omx --help")
  end
end
