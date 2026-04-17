class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.13.0.tgz"
  sha256 "d2dbafcdc4e7d69035175f17706eb381ed38e7f5c002945c71faaa66b966dd4b"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d5f14982d88675a0c3464fec99054a373ea6d735a7d7fa4aff94a6e48a14f3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d5f14982d88675a0c3464fec99054a373ea6d735a7d7fa4aff94a6e48a14f3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d5f14982d88675a0c3464fec99054a373ea6d735a7d7fa4aff94a6e48a14f3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4af357da7f08f1a0178c54677600d3cd1dee7489fe99301e5c224a09f3345d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4af357da7f08f1a0178c54677600d3cd1dee7489fe99301e5c224a09f3345d35"
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
