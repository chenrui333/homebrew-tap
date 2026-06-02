class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.18.8.tgz"
  sha256 "288aa2908301b3205f48312be6d293442d2e3dd5d1d376d84ea54feed77f043d"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abc2fab5a92276f653de5a94d9a90237f3caa8cdd288d09fbbb5abfce9168fc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abc2fab5a92276f653de5a94d9a90237f3caa8cdd288d09fbbb5abfce9168fc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abc2fab5a92276f653de5a94d9a90237f3caa8cdd288d09fbbb5abfce9168fc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aff620ceffaa63b33fa635680070bcc485a813230bc638d36b9b5dc5a3759407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aff620ceffaa63b33fa635680070bcc485a813230bc638d36b9b5dc5a3759407"
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
