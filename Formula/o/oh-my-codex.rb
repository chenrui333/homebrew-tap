class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.15.1.tgz"
  sha256 "93ecf4b72692850bceea3fda32684005b060fd33efe6f588aca60c4d144c292f"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e39b7ea924780e92d4867cc3fc6c8383a19e19c6e28fb434ae4794feaf107901"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e39b7ea924780e92d4867cc3fc6c8383a19e19c6e28fb434ae4794feaf107901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e39b7ea924780e92d4867cc3fc6c8383a19e19c6e28fb434ae4794feaf107901"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5c9760af21530e1004bf5044d10ca7316bccbdd002d6746090e2bf2e8c66577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5c9760af21530e1004bf5044d10ca7316bccbdd002d6746090e2bf2e8c66577"
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
