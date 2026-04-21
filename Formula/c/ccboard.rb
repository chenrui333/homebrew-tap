class Ccboard < Formula
  desc "Unified Claude Code management dashboard for TUI and web"
  homepage "https://github.com/FlorianBruniaux/ccboard"
  url "https://github.com/FlorianBruniaux/ccboard/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "b6fe42b5ce519e12b39b5c7b29346099bf021eec7a94800a9553496d7321ca6c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/FlorianBruniaux/ccboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27ccf5fe65121b5f0142a0855d76024016f7ea91086d3e1fb00d0cc84a3d43a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd6ae051e9d83c374088ad791c1a8eb39ad01c80adb9de52249125f33a9532a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1013d3910893dac35d9b2e98b18a677c08ea3cedef5cb170845d89962e45b850"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25c7e21d402b3652bb3b82d1a4059bc6a01f8bf183cf177167e2de7cd6f8a36d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65a52dfeec42b1bdc511c928dd3a17cbbe75646ca17fffd580351aa4309a3939"
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
