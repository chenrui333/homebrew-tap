class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.15.0.tgz"
  sha256 "216dd96cf0c014719aeb29b68449fadc9f4b442986d6675bb8a7c7b5a7b0191a"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "927ba41d25d75e75fffc9fbe33c7e5d5a69b711e93e74cb88648b772392fe4c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "927ba41d25d75e75fffc9fbe33c7e5d5a69b711e93e74cb88648b772392fe4c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "927ba41d25d75e75fffc9fbe33c7e5d5a69b711e93e74cb88648b772392fe4c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d725c159bce05f7a3102f189c8bee7de0dc7e989d4d6678235682fea5a14b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d725c159bce05f7a3102f189c8bee7de0dc7e989d4d6678235682fea5a14b51"
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
