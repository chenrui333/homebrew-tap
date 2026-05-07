class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.16.0.tgz"
  sha256 "6e5e552422fa5b872c754988f83d4865f17eeb80f21b771aaabd3287a44d876b"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec136f07ba1c25117b3aced56c2c860526b0e5d860f3a71bf0fd0cb721d0e55d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec136f07ba1c25117b3aced56c2c860526b0e5d860f3a71bf0fd0cb721d0e55d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec136f07ba1c25117b3aced56c2c860526b0e5d860f3a71bf0fd0cb721d0e55d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb93b2a414f6981f5eeb12cfeaef33e4d4c8cfc9ccb058d28c157948415503fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb93b2a414f6981f5eeb12cfeaef33e4d4c8cfc9ccb058d28c157948415503fc"
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
