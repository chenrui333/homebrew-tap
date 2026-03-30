class Ccboard < Formula
  desc "Unified Claude Code management dashboard for TUI and web"
  homepage "https://github.com/FlorianBruniaux/ccboard"
  url "https://github.com/FlorianBruniaux/ccboard/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "b1026cb2c0eedbe36584c24116857b3ede072607d986e808f7345ff724d2d1c2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/FlorianBruniaux/ccboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afc0c5e1bcded127810f597d041e0eb08199f2b91121de4392fae01fa1f16ec1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69a7f7dd3414b0d4490de2f73ec62b92b1cad1b039c056c910d602a6b2fc840b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "111f81751aa183e61d63139bd455768cfd33090b66ea0f1bdbe3211bf72d387d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dc29eb27be0e300af51ee3bff6237ce6d0d20acbf9ce866d90742b0881235f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f863d8f401b25e880ecec66f3e24c27d607095837dbadbfc9c1c05994f7dde5b"
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
