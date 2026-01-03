class Claudio < Formula
  desc "Hook-based audio plugin for Claude Code that plays contextual sounds"
  homepage "https://github.com/ctoth/claudio"
  url "https://github.com/ctoth/claudio/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "5129a0926a4e001e2a39492207d7369ddc1a56f050f87104a668315829c88d74"
  revision 1
  head "https://github.com/ctoth/claudio.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa3960a9bd9dea63e2ada902bed2426e6819dcea8a54f1063cdf4880dc64ac64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8978fbbe7692eadafcea468c8c757c82dbac3a2ed787e552e9ce6f6b134b7806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dfa66746317a9adad690eba1e2753972c5fe8fbe3b0692d3d0a038590bc8d82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d01b0df1dc01f1b8e1af96e9117685f6eac3c30dff087eb9e05729fe3eb3f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61be1c455a4247252f0c93c54ee1123ce953b15a95200d79385e84fa624cb6e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/claudio"

    generate_completions_from_executable(bin/"claudio", shell_parameter_format: :cobra)
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
