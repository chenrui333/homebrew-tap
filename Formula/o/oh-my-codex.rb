class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.16.3.tgz"
  sha256 "69b0a04283e06ec265fd6889fc7ab9b6e6f5a3187531988dbffbe0305dddfdde"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b97928a58bb09c54c33f3a70fe7d78b41c4520b27a607e4128a240911bfae9a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b97928a58bb09c54c33f3a70fe7d78b41c4520b27a607e4128a240911bfae9a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b97928a58bb09c54c33f3a70fe7d78b41c4520b27a607e4128a240911bfae9a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e60a95d51957d00de13716654c7e26acdda9fbb5cbb8550b1edda8f1db7322db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e60a95d51957d00de13716654c7e26acdda9fbb5cbb8550b1edda8f1db7322db"
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
