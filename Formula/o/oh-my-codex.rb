class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.14.1.tgz"
  sha256 "e4621d1bad03b60595a74b0cfed03108a49fdc30de12a3fdcce4bbbd65f68f92"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24d249eca82b1014a4d5feea80d8c7c4fd7f0bc1bd3ec50dedc9ac425b823f6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24d249eca82b1014a4d5feea80d8c7c4fd7f0bc1bd3ec50dedc9ac425b823f6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24d249eca82b1014a4d5feea80d8c7c4fd7f0bc1bd3ec50dedc9ac425b823f6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "970e64459e6ef8f500dbfff8ff7442d19e560953828af622608416cd728111e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "970e64459e6ef8f500dbfff8ff7442d19e560953828af622608416cd728111e1"
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
