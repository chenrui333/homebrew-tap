class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.12.3.tgz"
  sha256 "e089c5c20c6fc4057695bbfc502ed5c9550ffad9b75e8de424f8a45b390129b7"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f49926417315c865fdd3e0810321b92909612a8f60386b83273585a31253e27a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f49926417315c865fdd3e0810321b92909612a8f60386b83273585a31253e27a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f49926417315c865fdd3e0810321b92909612a8f60386b83273585a31253e27a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26de153e394980646800296b68fdaccbad225fe6bc15ed81254dbf9a0ba8ea3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26de153e394980646800296b68fdaccbad225fe6bc15ed81254dbf9a0ba8ea3c"
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
