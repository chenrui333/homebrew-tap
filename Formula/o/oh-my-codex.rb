class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.14.1.tgz"
  sha256 "e4621d1bad03b60595a74b0cfed03108a49fdc30de12a3fdcce4bbbd65f68f92"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d23abd9cd8f89866e7e547069f598097e4e13854d2278cf71914b524da873291"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d23abd9cd8f89866e7e547069f598097e4e13854d2278cf71914b524da873291"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d23abd9cd8f89866e7e547069f598097e4e13854d2278cf71914b524da873291"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12726aa7488840589a017e3cb1a95db0a49c75e63f68bb39859742d20f8fc722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12726aa7488840589a017e3cb1a95db0a49c75e63f68bb39859742d20f8fc722"
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
