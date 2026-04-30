class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.15.1.tgz"
  sha256 "93ecf4b72692850bceea3fda32684005b060fd33efe6f588aca60c4d144c292f"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a88a6822bef0f55614e1335ca7169ce3b9074fb10cb940139504631e06bed70e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a88a6822bef0f55614e1335ca7169ce3b9074fb10cb940139504631e06bed70e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a88a6822bef0f55614e1335ca7169ce3b9074fb10cb940139504631e06bed70e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "102d4a4cc0314f9ae519055ca2b15af25843b5888388b1f88d9cb2469df34a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "102d4a4cc0314f9ae519055ca2b15af25843b5888388b1f88d9cb2469df34a08"
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
