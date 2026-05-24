class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.18.2.tgz"
  sha256 "ef04dc2c1487ee85839b56fbc6e0d58a0eac2a70100e76d5989fa222edc22280"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb55791d764a4c0cbe77a3408c54e3517fef2831de1c9a692e6102543fb210bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb55791d764a4c0cbe77a3408c54e3517fef2831de1c9a692e6102543fb210bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb55791d764a4c0cbe77a3408c54e3517fef2831de1c9a692e6102543fb210bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3b1206fa06409c2943275b0b98f29486e2e32fb05eaa21ea0df5dc4b92c95c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3b1206fa06409c2943275b0b98f29486e2e32fb05eaa21ea0df5dc4b92c95c6"
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
