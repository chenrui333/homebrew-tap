class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.13.2.tgz"
  sha256 "b0b52caa00c1acad44431b7ac4fed8a66555b282ba9a6dec26bc791732d7dbb4"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b17341e94da17860b4e37b8647a1bbb74a6b0c0fd89a092dba1b6c439c6ce8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b17341e94da17860b4e37b8647a1bbb74a6b0c0fd89a092dba1b6c439c6ce8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b17341e94da17860b4e37b8647a1bbb74a6b0c0fd89a092dba1b6c439c6ce8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a1c02a55293eabe5a8790d0ef1aa14b29bcc22fd5cf0705f33ad365a052c208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a1c02a55293eabe5a8790d0ef1aa14b29bcc22fd5cf0705f33ad365a052c208"
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
