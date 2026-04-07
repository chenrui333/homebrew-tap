class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.12.1.tgz"
  sha256 "0d9164481be21288fc8102a3dd524edc83e317320437f4213c97d3b854a8cdd0"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fb1e746a5e5e9257a23a14bf402518b0f7ec0e855fb5f4f12165320ad9be8cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fb1e746a5e5e9257a23a14bf402518b0f7ec0e855fb5f4f12165320ad9be8cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fb1e746a5e5e9257a23a14bf402518b0f7ec0e855fb5f4f12165320ad9be8cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73a1268a91bebb6ee0f2b5c0e92d09847845e725b61576c3564f9547017702e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73a1268a91bebb6ee0f2b5c0e92d09847845e725b61576c3564f9547017702e4"
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
