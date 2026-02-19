class OeisTui < Formula
  desc "TUI and CLI for exploring the On-Line Encyclopedia of Integer Sequences (OEIS)"
  homepage "https://github.com/hako/oeis-tui"
  url "https://github.com/hako/oeis-tui/archive/refs/tags/1.0.0.tar.gz"
  sha256 "68bd20b731e17ef54708f7c26cdc901488e0948056bd5d519e16fd720f3c0d58"
  license "MIT"
  head "https://github.com/hako/oeis-tui.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oeis --version")

    output = shell_output("#{bin}/oeis fetch foo 2>&1", 1)
    assert_match "Invalid A-number format", output
  end
end
