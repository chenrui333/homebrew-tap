class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.12.0.tgz"
  sha256 "a30b4110a0484dc202aa9845358fcd3504f1557854feadcb6c75e67da9138f03"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47ee2d070cddd4bf96b1d2474c452aece7e01ac962eede272dbcc4c2caf85609"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47ee2d070cddd4bf96b1d2474c452aece7e01ac962eede272dbcc4c2caf85609"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47ee2d070cddd4bf96b1d2474c452aece7e01ac962eede272dbcc4c2caf85609"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "941ae7cc129d9624563c826a97e134441503fe0c31e09f5bea4cf633adb2acae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "941ae7cc129d9624563c826a97e134441503fe0c31e09f5bea4cf633adb2acae"
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
