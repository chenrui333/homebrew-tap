class Ccboard < Formula
  desc "Unified Claude Code management dashboard for TUI and web"
  homepage "https://github.com/FlorianBruniaux/ccboard"
  url "https://github.com/FlorianBruniaux/ccboard/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "969c4bff66f6ac955098314cb309549aba62d31233e000f8c3b5c91b1c6daa36"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/FlorianBruniaux/ccboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1518d511a0b4b4f024087b4bdcb21f6ef41897d5a4831d9af5badb419ed870f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cbe349707eeb22b2a8a87a84fb5c48a11e03274a67bbc9d3d848f0c9a849eaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5888326251d7328b940b9ffc339f2ccaf094055303bd86fd43a4596c4d444a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a661619604af7dd80dc0210fd32a39c5dd2e724ac3a0108f80138ee8631d8b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0451213abc1b7834ec28b422e31e471c5b48a8baa85003bc6b6e9fbd97cc595d"
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
