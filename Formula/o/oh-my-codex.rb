class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.17.3.tgz"
  sha256 "755f813511e2e2f71ff6edb77f00fe347580d2e937792404f363f4ef614d4c24"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd16816c2afac8b38e076ce8377b977bb4a6e6c9543da3af760fe37bba301b3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd16816c2afac8b38e076ce8377b977bb4a6e6c9543da3af760fe37bba301b3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd16816c2afac8b38e076ce8377b977bb4a6e6c9543da3af760fe37bba301b3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c59861551f2120d35e580822c3aff0187fe316cfbb16c4ec1ec58fdfaf1a676f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c59861551f2120d35e580822c3aff0187fe316cfbb16c4ec1ec58fdfaf1a676f"
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
