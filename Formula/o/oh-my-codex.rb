class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.16.4.tgz"
  sha256 "ade61e17c5629397ccaa782c8773ed0b3c3c0592710f71c6e809d82e70fc8598"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63453e91c47d6ed4b97a546c0e900069470686d361c8abb33bfe57cd98a487e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63453e91c47d6ed4b97a546c0e900069470686d361c8abb33bfe57cd98a487e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63453e91c47d6ed4b97a546c0e900069470686d361c8abb33bfe57cd98a487e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa784c399bfb39f691276363dafb6806346281c2fec9f9c7d67e69040896fcb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa784c399bfb39f691276363dafb6806346281c2fec9f9c7d67e69040896fcb3"
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
