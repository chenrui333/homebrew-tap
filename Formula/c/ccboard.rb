class Ccboard < Formula
  desc "Unified Claude Code management dashboard for TUI and web"
  homepage "https://github.com/FlorianBruniaux/ccboard"
  url "https://github.com/FlorianBruniaux/ccboard/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "969c4bff66f6ac955098314cb309549aba62d31233e000f8c3b5c91b1c6daa36"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/FlorianBruniaux/ccboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a550fb523c02705e857a9fb3cc2f3d7282854ba15a80a6bfe188a3066001b16a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35fc71f8773c68221ba58fc87468a521d451c2048400bf8da3065f7dba66c125"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53bf495a04ba31417ab269465fc53ae710f7a5c7862e52968f52e4e98b2dfd6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "235ae0abf7523227acdcd669d5db9c2b1a53f036689d5d6c502420a65b817f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d9add3cde24820e01a01fa998eccb5bf282db4dd9bd108abe2a8f29a7e6d4f0"
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
