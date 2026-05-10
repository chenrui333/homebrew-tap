class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.16.3.tgz"
  sha256 "69b0a04283e06ec265fd6889fc7ab9b6e6f5a3187531988dbffbe0305dddfdde"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62228dd5e1af2e9f4562c91788492536f32562c6006c6a1a0d38f63ff516c6a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62228dd5e1af2e9f4562c91788492536f32562c6006c6a1a0d38f63ff516c6a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62228dd5e1af2e9f4562c91788492536f32562c6006c6a1a0d38f63ff516c6a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "915b4acdeef953663c1c6c745740ae4cd7bb84a95f403f2e0dd1be8d9364d9e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "915b4acdeef953663c1c6c745740ae4cd7bb84a95f403f2e0dd1be8d9364d9e4"
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
