class NanoAgent < Formula
  desc "Minimal Rust shell agent with OpenAI-compatible model calls"
  homepage "https://github.com/skorotkiewicz/nano-agent"
  url "https://github.com/skorotkiewicz/nano-agent/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "4279e871b83e1852ecb132488f5f46ebbd45c4da4eed01f2a0f605400ce31953"
  license "MIT"
  head "https://github.com/skorotkiewicz/nano-agent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2040472bbd86affba6a40eddf6798f0034f3e61fa61b87f66dedfc6ac35d3c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecee5fc769be97a74ab1f62988e1ecae608fdc91a8bd1045426bdffeb9c661da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b378a778e61b537a19132f86bc7b347feca6d52bd83dfde05a23f1593bccbeb4"
    sha256 cellar: :any,                 arm64_linux:   "17e3cc7c301a37622a53860aa4ad06edd142f9016be18cedd356583f25aed601"
    sha256 cellar: :any,                 x86_64_linux:  "a38b18b7e7e824f7686373d5834b2033dc7dd7fad273decd15a5f93087e75b7c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/nano-agent --version 2>&1", 1)
    assert_match "OPENAI_API_KEY", output
  end
end
