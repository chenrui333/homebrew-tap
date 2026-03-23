class Ccboard < Formula
  desc "Unified Claude Code management dashboard for TUI and web"
  homepage "https://github.com/FlorianBruniaux/ccboard"
  url "https://github.com/FlorianBruniaux/ccboard/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "2fc1d124d128f1d26f8994c178271de07f3c826cc9c82b1f943e20ed50ed3c98"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/FlorianBruniaux/ccboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0592168844c547280b6febe6062d3f2ce514d88725753b045b69a37190c93736"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02379c9dd3edc532703eccdecd1b356628a453451c34d95e7502778c1d44fe30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "454a3cd87530d20673b551234b62f8d1b1dd3801abc0846938a0d176898b14a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb766626f80a5c3572445323b3cb9960733ea60153527a548d85aff0fe734cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49f190fe7e8237fbe9bb62085d7a76fd42c951a3cd8f6ce0048db525c4e50a1e"
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
