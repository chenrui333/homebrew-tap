class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.15.3.tgz"
  sha256 "9a14f71764eb7b8868b3712c346cca707c50cdd4c65192d87ad93986b1db7505"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c126236cf1bdf5939d10a04d968ba1d24c480842c7bc99f335b74595345ec56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c126236cf1bdf5939d10a04d968ba1d24c480842c7bc99f335b74595345ec56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c126236cf1bdf5939d10a04d968ba1d24c480842c7bc99f335b74595345ec56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88eb2a6ade9bb9ad5c9f3adaf7aa9829dce85f3265765f7e221c3430541ead87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88eb2a6ade9bb9ad5c9f3adaf7aa9829dce85f3265765f7e221c3430541ead87"
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
