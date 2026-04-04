class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.11.13.tgz"
  sha256 "ab6defdacac3f0eea704f024aa9c18ab43b351bf55e14618d9317ea866b71c94"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec916307207a0e93bbe3755f901212bcdfc255f7ac0a54cc9dc6e00dc66b13bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec916307207a0e93bbe3755f901212bcdfc255f7ac0a54cc9dc6e00dc66b13bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec916307207a0e93bbe3755f901212bcdfc255f7ac0a54cc9dc6e00dc66b13bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2049ba2b924487d883eedfb59885250d9eda8e996e2720f0c11a60c6c788225f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2049ba2b924487d883eedfb59885250d9eda8e996e2720f0c11a60c6c788225f"
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
