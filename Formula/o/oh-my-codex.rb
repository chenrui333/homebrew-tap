class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.14.3.tgz"
  sha256 "bef9a9692d96af9b8cff2a50c4398ff86221b267f5ebbecb03c0f68456f29fda"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d279ae423d9f4c4a3a8facf1f8382d4522878aacfe3df731253b41b1e59cb0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d279ae423d9f4c4a3a8facf1f8382d4522878aacfe3df731253b41b1e59cb0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d279ae423d9f4c4a3a8facf1f8382d4522878aacfe3df731253b41b1e59cb0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "740831e361dbe615df13efd2ee34674824e12023e24cf3edc55f26e58d7df502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "740831e361dbe615df13efd2ee34674824e12023e24cf3edc55f26e58d7df502"
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
