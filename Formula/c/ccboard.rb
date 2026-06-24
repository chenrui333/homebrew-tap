class Ccboard < Formula
  desc "Unified Claude Code management dashboard for TUI and web"
  homepage "https://github.com/FlorianBruniaux/ccboard"
  url "https://github.com/FlorianBruniaux/ccboard/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "cb4687c7ddf8b060ec97c9764023426c111d01bd547a09a7c24223ea5fdaefd8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/FlorianBruniaux/ccboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2afd7cccd9f7f7b2b0feba59c813193f8d2cbd90c5b0eb1e9afb520b7d2b0c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a4113cc46a1f9e74b8b27e003e3d25f3f93c02ca1da870a371ab4c85ab4ae3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "268a9d6d526883d75bf375f723c52803791b73139585e3dbeb15dd46d0d2bba7"
    sha256 cellar: :any,                 arm64_linux:   "a7a6f76c0cacc929f82b8c44a73b39a47fe6fea62bb1b0b7eb419abf4234103b"
    sha256 cellar: :any,                 x86_64_linux:  "7ab94e608b9320c6392eb613616a464d0bfce1f26d4d27ce719c93bb830bd74d"
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
