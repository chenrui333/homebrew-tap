class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.17.3.tgz"
  sha256 "755f813511e2e2f71ff6edb77f00fe347580d2e937792404f363f4ef614d4c24"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7f16222f2f6a2ce4f1831a51dfedde6f41fd1f13820562b49e58a8dedc529a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7f16222f2f6a2ce4f1831a51dfedde6f41fd1f13820562b49e58a8dedc529a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7f16222f2f6a2ce4f1831a51dfedde6f41fd1f13820562b49e58a8dedc529a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e58f79b9a099bc58e58d8770ac2d8faeb72961be171a8a55b21969b1e3ef033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e58f79b9a099bc58e58d8770ac2d8faeb72961be171a8a55b21969b1e3ef033"
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
