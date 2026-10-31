class UnrealAgent < Formula
  desc "Async-first agent harness with a JSONL runner"
  homepage "https://github.com/unreallabsai/unreal-agent"
  url "https://github.com/unreallabsai/unreal-agent/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "743d14c73106bb9b76a56f2f3138c1261c178b70c36738557bb63d01d59f0490"
  license "MIT"
  head "https://github.com/unreallabsai/unreal-agent.git", branch: "main"

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
