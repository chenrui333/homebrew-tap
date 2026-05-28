class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.18.6.tgz"
  sha256 "6981a4b318ebd1ee56057aaf3075a012350bcc28e5565f91f75972864c60361b"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40af9fffc0cba437c7002368ffa293bd516c35f26580940466593349d1c7ad7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40af9fffc0cba437c7002368ffa293bd516c35f26580940466593349d1c7ad7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40af9fffc0cba437c7002368ffa293bd516c35f26580940466593349d1c7ad7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ba38c07277ea39db41506290f429f991fea34316661b18760d1215904d380b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ba38c07277ea39db41506290f429f991fea34316661b18760d1215904d380b8"
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
