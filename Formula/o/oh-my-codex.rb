class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.18.14.tgz"
  sha256 "d572cc3a18ba91e32b2939ad6c5fd6a7548b9f5c3fbe687d449dfddc5784c036"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91716b982fa123d427144a4b5dc8ad0ab810495fb2b53a7fd2c9e3ecf6468aa2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91716b982fa123d427144a4b5dc8ad0ab810495fb2b53a7fd2c9e3ecf6468aa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91716b982fa123d427144a4b5dc8ad0ab810495fb2b53a7fd2c9e3ecf6468aa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83086dc07a80d21b6a4336ee50371b6052700a0b1b2d15bfd5ebb587b1091d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83086dc07a80d21b6a4336ee50371b6052700a0b1b2d15bfd5ebb587b1091d39"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    pkg = libexec/"lib/node_modules/oh-my-codex/package.json"
    assert_match version.to_s, shell_output("node -p \"require('#{pkg}').version\"").strip

    require "open3"

    output, status = Open3.capture2e(bin/"omx", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "failed to launch codex", output
  end
end
