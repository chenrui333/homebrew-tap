class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.18.10.tgz"
  sha256 "5a3eed804dc867ca0678e5d41f02934839396946a0a091c89a11272a8f8a805d"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea27e882da5f57bbc174a8df3c9ab846f5f9e3609c38b23b12d3b138c43bfcf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea27e882da5f57bbc174a8df3c9ab846f5f9e3609c38b23b12d3b138c43bfcf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea27e882da5f57bbc174a8df3c9ab846f5f9e3609c38b23b12d3b138c43bfcf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1e801a5a33731930869cbf44e6f1a30e3ce77228e8ae4cb54c51b066e08cc80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1e801a5a33731930869cbf44e6f1a30e3ce77228e8ae4cb54c51b066e08cc80"
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
