class Prempti < Formula
  desc "Falco-powered policy and visibility layer for AI coding agents"
  homepage "https://github.com/falcosecurity/prempti"
  url "https://github.com/falcosecurity/prempti/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "87671d3ee65bed1a37d0ab884f1d3db2600111263b69a76f08b683f67236cd9f"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/prempti.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "tools/premptictl")
    system "cargo", "install", *std_cargo_args(path: "hooks/claude-code")
  end

  test do
    output = shell_output("#{bin}/premptictl --help 2>&1")
    assert_match "premptictl", output
    assert_match "hook add", output

    output = pipe_output("#{bin}/claude-interceptor", "{}\n")
    assert_match "permissionDecision", output
    assert_match "broker unavailable", output
  end
end
