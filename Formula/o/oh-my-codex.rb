class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.18.4.tgz"
  sha256 "7b6bdd011d896eb71b538787988b1aa99248b39314f5982a32c87c306c82c06a"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a15e5733475f08604ed1280cc9e34a824aa44327f5c62effd2d541eb3eae179d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a15e5733475f08604ed1280cc9e34a824aa44327f5c62effd2d541eb3eae179d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a15e5733475f08604ed1280cc9e34a824aa44327f5c62effd2d541eb3eae179d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd4e402b01f30cd00014eb72270aa8fa27948d7b38f7d4e80435be42b5c6caf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd4e402b01f30cd00014eb72270aa8fa27948d7b38f7d4e80435be42b5c6caf8"
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
