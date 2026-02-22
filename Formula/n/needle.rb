class Needle < Formula
  desc "TUI that highlights the GitHub PRs that need you"
  homepage "https://github.com/cesarferreira/needle"
  url "https://github.com/cesarferreira/needle/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "e9489a789dc45ef11783b451da215b932bd1f8d76da2287e9a5c536d09ae88a2"
  license "MIT"
  head "https://github.com/cesarferreira/needle.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needle --version")

    output = shell_output("#{bin}/needle --demo 2>&1", 1)
    assert_match "Not a TTY", output
  end
end
