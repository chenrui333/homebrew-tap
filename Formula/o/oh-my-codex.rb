class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.18.0.tgz"
  sha256 "9eace15049f020baaa7772ed09b9c5577691c5aa55c1a3f190ac1441ec786900"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29ef31b2802887a5c2f22890c3f884bf80494da75c427719abbfff453a82d985"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29ef31b2802887a5c2f22890c3f884bf80494da75c427719abbfff453a82d985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29ef31b2802887a5c2f22890c3f884bf80494da75c427719abbfff453a82d985"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66be399cc71fe7d198eee5837db8fb938be94aeecb9424735a27cdaf9550fd47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66be399cc71fe7d198eee5837db8fb938be94aeecb9424735a27cdaf9550fd47"
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
