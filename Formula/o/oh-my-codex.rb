class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.16.2.tgz"
  sha256 "c4fcc11b028817aa57874ceb694c6e7f30ca0a15073452e4ed6c5c8201acb4db"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a4407dc316af0dbd84605cd22187bb0cfbe10f90d639a8547c2e954d7c3969f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a4407dc316af0dbd84605cd22187bb0cfbe10f90d639a8547c2e954d7c3969f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a4407dc316af0dbd84605cd22187bb0cfbe10f90d639a8547c2e954d7c3969f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c04cd8c975bf5d21741650e72abca598efab1893a34a2174b0562742d5f8615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c04cd8c975bf5d21741650e72abca598efab1893a34a2174b0562742d5f8615"
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
