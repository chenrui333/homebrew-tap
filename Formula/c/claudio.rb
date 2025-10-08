class Claudio < Formula
  desc "Hook-based audio plugin for Claude Code that plays contextual sounds"
  homepage "https://github.com/ctoth/claudio"
  url "https://github.com/ctoth/claudio/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "5129a0926a4e001e2a39492207d7369ddc1a56f050f87104a668315829c88d74"
  revision 1
  head "https://github.com/ctoth/claudio.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf2b62f210f639511abbdba3d8c598a91a0c2a4621ce7c633a6d2460e992cb99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e78c592f1e13477a51d1f011e5b7d2d484a24f3117195939ea2e33455d69bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b4274024c8ca0a12e8c839b53a81d2e47455b49991e64658703ccdd5f206136"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/claudio"

    generate_completions_from_executable(bin/"claudio", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claudio --version")

    output = shell_output("#{bin}/claudio analyze usage")
    assert_match "No sound usage data found for the specified criteria", output

    # Test that the binary can process hook events with valid JSON input
    json_input = <<~JSON
      {
        "session_id": "test-session-123",
        "hook_event_name": "PostToolUse",
        "tool_name": "Bash",
        "tool_input": {"command": "echo test"},
        "tool_response": {"stdout": "test output", "stderr": ""}
      }
    JSON

    output = pipe_output("#{bin}/claudio --silent 2>&1", json_input)
    assert_match "INFO tracking database initialized successfully", output
  end
end
