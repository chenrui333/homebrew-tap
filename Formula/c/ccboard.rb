class Ccboard < Formula
  desc "Unified Claude Code management dashboard for TUI and web"
  homepage "https://github.com/FlorianBruniaux/ccboard"
  url "https://github.com/FlorianBruniaux/ccboard/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "b1026cb2c0eedbe36584c24116857b3ede072607d986e808f7345ff724d2d1c2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/FlorianBruniaux/ccboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3889e6654b0f1b451d484731dff3c1678d8eb9fbf3e04825f5b0672d9a1d14ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bf8d2e42be30b2e33d4355bbf77987d5cda1ceeb654d001776379dc41d91c30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f2894d4836d33b0a5cc1f515821884a3a3366302bd9442706607ae7b576cc81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cf0e9f6244c2cfe11e32646c38641ffb6ec2493bb442ddd1850213c7230ca92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7687689268f66e4426599306ff15cb946c48e26e88d9c20d3696ee73c43273d"
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
