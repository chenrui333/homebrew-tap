class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.12.3.tgz"
  sha256 "e089c5c20c6fc4057695bbfc502ed5c9550ffad9b75e8de424f8a45b390129b7"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8982ecbb878c7fb0fa7e557ae080930742075d385d1d97732600e1282b058905"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8982ecbb878c7fb0fa7e557ae080930742075d385d1d97732600e1282b058905"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8982ecbb878c7fb0fa7e557ae080930742075d385d1d97732600e1282b058905"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62b18ee896e7fe11e960c2f3434b256472a2f32f2ad1c891b39a75b4f22fb3aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62b18ee896e7fe11e960c2f3434b256472a2f32f2ad1c891b39a75b4f22fb3aa"
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
