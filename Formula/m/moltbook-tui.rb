class MoltbookTui < Formula
  desc "TUI client for Moltbook, the social network for AI Agents"
  homepage "https://terminaltrove.com/moltbook-tui/"
  url "https://github.com/terminaltrove/moltbook-tui/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b970101d47776b976ef848424454742a047fcaf1b4fb24f4d0bc4bfdc5b954b7"
  license "MIT"
  revision 1
  head "https://github.com/terminaltrove/moltbook-tui.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moltbook --version")

    ENV["TERM"] = "xterm"
    cmd = if OS.mac?
      "printf 'q' | script -q /dev/null #{bin}/moltbook --no-refresh"
    else
      "printf 'q' | script -q -c '#{bin}/moltbook --no-refresh' /dev/null"
    end

    assert system(cmd)
  end
end
