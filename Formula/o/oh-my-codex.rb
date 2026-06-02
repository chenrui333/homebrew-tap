class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.18.8.tgz"
  sha256 "288aa2908301b3205f48312be6d293442d2e3dd5d1d376d84ea54feed77f043d"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5884c0f55db6aa90ea7c2aacfa6c8a4e4fc4a2b467100b4f7c7e633662318ae5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5884c0f55db6aa90ea7c2aacfa6c8a4e4fc4a2b467100b4f7c7e633662318ae5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5884c0f55db6aa90ea7c2aacfa6c8a4e4fc4a2b467100b4f7c7e633662318ae5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4736cba28fbe7cc71fb26ee47bdb57b07e76956e644865d106cef115c308d22c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4736cba28fbe7cc71fb26ee47bdb57b07e76956e644865d106cef115c308d22c"
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
