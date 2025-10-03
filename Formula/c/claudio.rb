class Claudio < Formula
  desc "Hook-based audio plugin for Claude Code that plays contextual sounds"
  homepage "https://github.com/ctoth/claudio"
  url "https://github.com/ctoth/claudio/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "5129a0926a4e001e2a39492207d7369ddc1a56f050f87104a668315829c88d74"
  head "https://github.com/ctoth/claudio.git", branch: "master"

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
