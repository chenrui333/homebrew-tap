class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.18.2.tgz"
  sha256 "ef04dc2c1487ee85839b56fbc6e0d58a0eac2a70100e76d5989fa222edc22280"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd4d36e60d3bad902c7c69945eb0f1dedcdbe0f99668dba939b90429df48e092"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd4d36e60d3bad902c7c69945eb0f1dedcdbe0f99668dba939b90429df48e092"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd4d36e60d3bad902c7c69945eb0f1dedcdbe0f99668dba939b90429df48e092"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3abadfbeeb7b7b1a801bbf57ff9c38aaed54ee6aa6fd570940d2ba507ad483b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3abadfbeeb7b7b1a801bbf57ff9c38aaed54ee6aa6fd570940d2ba507ad483b"
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
