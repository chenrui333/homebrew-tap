class Ccboard < Formula
  desc "Unified Claude Code management dashboard for TUI and web"
  homepage "https://github.com/FlorianBruniaux/ccboard"
  url "https://github.com/FlorianBruniaux/ccboard/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "24a59674b61cfc4bb8b95fb85725d9bd92ab8e4d7fc63f7566618e32dc5ea76a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/FlorianBruniaux/ccboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dcfe6877eeac4864ca1ceb4e9789a71e316ae22488ed22e4df33ea6a09c006a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bb81d7010d728bc25aa7a08474d3a7e95cb2854eb3a1905196ebc8487ce2aab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b875e993adf4eeb2976aa52c62e071c23cc9e1f554fd11bbd4b499fa04ef5c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67060d39706206ffc88c325569b3da34fedc3a416b882d88892bdac4c8f44434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ca7c10a885c368dfa5195f9a0018eb0e9e513368b2be7a30ddcc3dcebdadf6b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ccboard")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccboard --version")

    claude_home = testpath/".claude"
    claude_home.mkpath
    ENV["CCBOARD_CLAUDE_HOME"] = claude_home

    output = shell_output("#{bin}/ccboard stats")
    assert_match "Sessions indexed:", output
  end
end
