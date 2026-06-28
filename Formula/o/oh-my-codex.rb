class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.18.16.tgz"
  sha256 "33b96e7792dec6cff7bc0c22fa86e03a46f93b62ba50f0bfcc330e97701f2eaa"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30b372cc644407c54bbe664e02b99aec496929b7340cfd73f789b3423a165a1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30b372cc644407c54bbe664e02b99aec496929b7340cfd73f789b3423a165a1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30b372cc644407c54bbe664e02b99aec496929b7340cfd73f789b3423a165a1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00a5a54c7c6f66a79bce73799a33190c53ed831c8d81333e787d03277a0e6965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00a5a54c7c6f66a79bce73799a33190c53ed831c8d81333e787d03277a0e6965"
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
