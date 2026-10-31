class UnrealAgent < Formula
  desc "Async-first agent harness with a JSONL runner"
  homepage "https://github.com/unreallabsai/unreal-agent"
  url "https://github.com/unreallabsai/unreal-agent/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "743d14c73106bb9b76a56f2f3138c1261c178b70c36738557bb63d01d59f0490"
  license "MIT"
  head "https://github.com/unreallabsai/unreal-agent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d0847162030527901b8647e16c3f071e70eb3cf4a37dbc19255d4ac20257f29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d0847162030527901b8647e16c3f071e70eb3cf4a37dbc19255d4ac20257f29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cfa820ecdd67d52f6b334764f5558b4dbf7e41e11b6ce4f8c872dc28d3399af"
    sha256 cellar: :any,                 x86_64_linux:  "108e3cb54f84cf49d2c7d4ec5362cc31301f61c16915b8e1df56e783ea2aa53a"
  end

  depends_on "go" => :build
  depends_on "bash"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: libexec/"unreal-agent-runner"), "./cmd/unreal-agent-runner"
    (bin/"unreal-agent-runner").write_env_script libexec/"unreal-agent-runner",
                                               PATH: "#{formula_opt_bin("bash")}:$PATH"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    request = { prompt: "offline fixture", max_output_tokens: 0 }.to_json
    output = shell_output("#{bin}/unreal-agent-runner '#{request}' 2>/dev/null", 1)
    event = JSON.parse(output)
    assert_equal "error", event.fetch("type")
    assert_equal "max_output_tokens must be positive", event.fetch("message")

    output = shell_output("#{bin}/unreal-agent-runner '{}' 2>/dev/null", 1)
    assert_equal "messages must be set", JSON.parse(output).fetch("message")
  end
end
