class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.18.13.tgz"
  sha256 "213cdca65b62f56bf7640a891ff41699b9fe93aeae871b28174ade824faf6e4f"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8d07b4758094accbb2ae740ee067109e40c6b95a25091c80bbf24801a32a486"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8d07b4758094accbb2ae740ee067109e40c6b95a25091c80bbf24801a32a486"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8d07b4758094accbb2ae740ee067109e40c6b95a25091c80bbf24801a32a486"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "249f2e58038bafc6092bb8e724b8734a4140a348d34e14e1b8b7bda4f1beeee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "249f2e58038bafc6092bb8e724b8734a4140a348d34e14e1b8b7bda4f1beeee7"
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
