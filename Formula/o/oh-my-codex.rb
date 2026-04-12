class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.12.5.tgz"
  sha256 "5817268f3d83ed861ad25492494133190d957a2944c28497f5221e2debfe03cd"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56ef4aaa5f3cbf756bce4a00a8241075657632be79cec72259496f2b7ae06873"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56ef4aaa5f3cbf756bce4a00a8241075657632be79cec72259496f2b7ae06873"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56ef4aaa5f3cbf756bce4a00a8241075657632be79cec72259496f2b7ae06873"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db40667e8767d637f5b80d86937bd4e7ef6c367a52e9059a45d53b56a59a7954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db40667e8767d637f5b80d86937bd4e7ef6c367a52e9059a45d53b56a59a7954"
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
