class MoltbookTui < Formula
  desc "TUI client for Moltbook, the social network for AI Agents"
  homepage "https://github.com/terminaltrove/moltbook-tui"
  url "https://github.com/terminaltrove/moltbook-tui/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "56624e66f4de1232e8db1dea8d52b547ec3a8d7a583a892733abfb9e8c21bc41"
  license "MIT"
  head "https://github.com/terminaltrove/moltbook-tui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c17e33845e3c7e6ac1b16ca1974217e66f9f8856e6ee332d17eedbae132e66d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8f242abda19447da339225119d9aabeb064f143b144600f245957ccfb2a23f6"
    sha256 cellar: :any,                 arm64_linux:   "ecfa5023e525933697f03ab15a18684567f07194f929238193beaac7119363bf"
    sha256 cellar: :any,                 x86_64_linux:  "dcdfa083ebc009ffc5ce923577650845e272d1716c21484e8597d8cd8c0828ac"
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
