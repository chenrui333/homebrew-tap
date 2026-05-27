class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.18.4.tgz"
  sha256 "7b6bdd011d896eb71b538787988b1aa99248b39314f5982a32c87c306c82c06a"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "260847a7acfe930d1b72b695ec5ed638f948a02b5f7dae8ca664080097d4c5db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "260847a7acfe930d1b72b695ec5ed638f948a02b5f7dae8ca664080097d4c5db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "260847a7acfe930d1b72b695ec5ed638f948a02b5f7dae8ca664080097d4c5db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9b0ea8ea99ce5333637445f1293b091e9eeb39d9513e0d4dd64e060ae835c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9b0ea8ea99ce5333637445f1293b091e9eeb39d9513e0d4dd64e060ae835c93"
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
