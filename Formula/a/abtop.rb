class Abtop < Formula
  desc "Terminal monitor for AI coding agent sessions"
  homepage "https://github.com/graykode/abtop"
  url "https://github.com/graykode/abtop/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "6664cec768299277085dcebdca6d07fcd57137cbb3ff4fe61c222fa9ca6b34d1"
  license "MIT"
  head "https://github.com/graykode/abtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5daf3786d587727865762f00ed9636afec676c7eb42f8f1b59a02136b9ec830"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d857f3e34a2ca09e22c017bec7a449d6929c8c6643e1e9cedb99ff8cf79886b"
    sha256 cellar: :any,                 arm64_linux:   "48a81084b501c53e09b0b3009164c24cd3bb003c5ddcb4998f9307268f7e7cf6"
    sha256 cellar: :any,                 x86_64_linux:  "3521217f7e1515b614518623ff57ff005e6a71b6eb0fbc5e6d6d3bf30efbd795"
  end

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
