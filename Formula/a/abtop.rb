class Abtop < Formula
  desc "Terminal monitor for AI coding agent sessions"
  homepage "https://github.com/graykode/abtop"
  url "https://github.com/graykode/abtop/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "6664cec768299277085dcebdca6d07fcd57137cbb3ff4fe61c222fa9ca6b34d1"
  license "MIT"
  head "https://github.com/graykode/abtop.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abtop --version")
    snapshot = JSON.parse(shell_output("#{bin}/abtop --json --demo"))
    assert snapshot.fetch("sessions").any? { |session| session.fetch("project_name") == "webshop" }
    assert snapshot.fetch("sessions").any? { |session| session.fetch("agent_cli") == "claude" }
  end
end
