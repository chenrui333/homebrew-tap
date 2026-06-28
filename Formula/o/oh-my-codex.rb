class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.18.16.tgz"
  sha256 "33b96e7792dec6cff7bc0c22fa86e03a46f93b62ba50f0bfcc330e97701f2eaa"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b0caefb01a5d367eace0ace377ea4b278b2b467f265ffcdd41a44fb1201690a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b0caefb01a5d367eace0ace377ea4b278b2b467f265ffcdd41a44fb1201690a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b0caefb01a5d367eace0ace377ea4b278b2b467f265ffcdd41a44fb1201690a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "148f2c19f2481cede4dc95a1b567fb7fa901640e89b1f1b4fa93676786440a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "148f2c19f2481cede4dc95a1b567fb7fa901640e89b1f1b4fa93676786440a7f"
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
