class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.19.1.tgz"
  sha256 "ad8e81083f54941668d0f7f3824103d8abd74b40e727265f538cb66caaf9efb6"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6188a75c7bb6426c672a5ac70878fabcc2b77135ae05c83572c6377e4f800df9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6188a75c7bb6426c672a5ac70878fabcc2b77135ae05c83572c6377e4f800df9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6188a75c7bb6426c672a5ac70878fabcc2b77135ae05c83572c6377e4f800df9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8397cc308ba291ea412eab740cb225ef552949864eecbec7e7aeebdff1c3c445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8397cc308ba291ea412eab740cb225ef552949864eecbec7e7aeebdff1c3c445"
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
