class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.17.1.tgz"
  sha256 "24584560a0019bb6e32e035a5ee4a461302180321072ed4015b3c90873c3e515"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bf6e75fff6f157e2536914d484652f008952df64253db752f905a55a670af25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bf6e75fff6f157e2536914d484652f008952df64253db752f905a55a670af25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bf6e75fff6f157e2536914d484652f008952df64253db752f905a55a670af25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8df567230ea70f514ddc34bb39e3e2db379dbe81ab0d1398e9ce4066ac93bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8df567230ea70f514ddc34bb39e3e2db379dbe81ab0d1398e9ce4066ac93bbb"
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
