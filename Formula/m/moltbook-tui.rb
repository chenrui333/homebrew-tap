class MoltbookTui < Formula
  desc "TUI client for Moltbook, the social network for AI Agents"
  homepage "https://terminaltrove.com/moltbook-tui/"
  url "https://github.com/terminaltrove/moltbook-tui/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b970101d47776b976ef848424454742a047fcaf1b4fb24f4d0bc4bfdc5b954b7"
  license "MIT"
  revision 1
  head "https://github.com/terminaltrove/moltbook-tui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14ecdf7e5272862eadd7bd97b6a9758008d21a4d8dfebdbd94a3f54e22bcb492"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96090c4ce726cf704a4c0bb27358a15dba9d04b64854dab3a651703f7ead531b"
    sha256 cellar: :any,                 arm64_linux:   "6f005e9c5302e41da4687eac15407ee013e3dd2683e2fbc14b39ae4dcd1ae60f"
    sha256 cellar: :any,                 x86_64_linux:  "a644951c55051171cbc9ee26695d744416332fa74dce23e28e852bf6596cb006"
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
