class NanoAgent < Formula
  desc "Minimal Rust shell agent with OpenAI-compatible model calls"
  homepage "https://github.com/skorotkiewicz/nano-agent"
  url "https://github.com/skorotkiewicz/nano-agent/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "88f1bb9f3dee180807f65d10167e35eb3f0eb0e93e6189bda341e5434e601407"
  license "MIT"
  head "https://github.com/skorotkiewicz/nano-agent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32cf456e1fed7107b8555aa6f47851bc856b0bc4688d2fbebb2807e1e7154fa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d94c8b1dedbacf742b48cc940d8a4a03f72da84e9d2788d2b776e3da16e4512"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db8440999487f20db0228ae9e1bd635678e4089c0d1ba56378cd6424059dfd83"
    sha256 cellar: :any,                 arm64_linux:   "4a52348cd22001389cf7440b604983234dffb9ff03770234627378aa2b50b1ed"
    sha256 cellar: :any,                 x86_64_linux:  "2551bfd11e0bfc7333deb2fa8fcbe1e08e4699992e1b25c08a925a8e571367fd"
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
