class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.14.3.tgz"
  sha256 "bef9a9692d96af9b8cff2a50c4398ff86221b267f5ebbecb03c0f68456f29fda"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e64dff17f8e8670eafa34a3221290919372511f611756ea1ee5ddc0aefa903c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e64dff17f8e8670eafa34a3221290919372511f611756ea1ee5ddc0aefa903c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e64dff17f8e8670eafa34a3221290919372511f611756ea1ee5ddc0aefa903c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48a0e5e472cdd87be073e21924581848ffbc8a2d523d34c0fd6e3ccb961213d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48a0e5e472cdd87be073e21924581848ffbc8a2d523d34c0fd6e3ccb961213d9"
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
