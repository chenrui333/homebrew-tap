class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.18.10.tgz"
  sha256 "5a3eed804dc867ca0678e5d41f02934839396946a0a091c89a11272a8f8a805d"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff50ecf087de6e43d70278da7402a4689b7dbdebc04c78eec00f817359a3cd0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff50ecf087de6e43d70278da7402a4689b7dbdebc04c78eec00f817359a3cd0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff50ecf087de6e43d70278da7402a4689b7dbdebc04c78eec00f817359a3cd0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25fb291a3b2afdcd30651a14486b1b2a68ab07dd0a62c96f919f359c605fb113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25fb291a3b2afdcd30651a14486b1b2a68ab07dd0a62c96f919f359c605fb113"
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
