class Mamediff < Formula
  desc "TUI editor for managing unstaged and staged Git diffs"
  homepage "https://github.com/sile/mamediff"
  url "https://github.com/sile/mamediff/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "9ec2412b6d472b9f122218a2f82c1a098f9b484c4970e69dfd3e71e92ea4eb0c"
  license "MIT"
  head "https://github.com/sile/mamediff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e3fa2109bc6dcdc89d181ca050cb1a6dcdf18f4158711266bfead395abf848c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a650fa41a1b7618e78a8d9c96777593d2fd843bbe77346ed839d550ff89b802e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "371adab6dd6e313cb9cdee84d35c1389c38fd55bc8480bf76c39ae38a8e85e8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e037faaf78360d5e87dc9c99bd052fc15f55eddeee80a1160f6f641644b5350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea55f9a5bee6bc08fc28eef1b428d2af5033e7a5eb4d4f10fc845b5bfae4e86b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mamediff --version")

    output = shell_output("#{bin}/mamediff 2>&1", 1)
    assert_match "no `git` command found, or not a Git directory", output
  end
end
