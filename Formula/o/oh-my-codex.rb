class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.12.4.tgz"
  sha256 "f9428ef0a38f5218f1b63dc00715ec8a4f71a4122bc37f7c0d8bc5f751bc8b59"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c7f904ac6d4c18b2ae6255b7ec00a6e60771b476cac6166d43b285c30d5e041"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c7f904ac6d4c18b2ae6255b7ec00a6e60771b476cac6166d43b285c30d5e041"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c7f904ac6d4c18b2ae6255b7ec00a6e60771b476cac6166d43b285c30d5e041"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "395ea88ed5434dfb287409c8a6ba4475786defe63cb90ad1176c7d07f47d2400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "395ea88ed5434dfb287409c8a6ba4475786defe63cb90ad1176c7d07f47d2400"
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
