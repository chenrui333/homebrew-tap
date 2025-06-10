class Mamediff < Formula
  desc "TUI editor for managing unstaged and staged Git diffs"
  homepage "https://github.com/sile/mamediff"
  url "https://github.com/sile/mamediff/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "41ccb6db241f4b0bee5a2b7a95735d15bcc30f1d7e9da54fc66e5c2f8e680fe0"
  license "MIT"
  head "https://github.com/sile/mamediff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2d8f02451d50aacdae5de36935ee6f68470320f2593d4819f479cad35d9d5fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d0afb6e08b193f738a642efbae0b5853daa377b68cf928e23f9815f8cb2ae86"
    sha256 cellar: :any_skip_relocation, ventura:       "b4978cda6e2882da40c0770f73539198afb555757772b6716d2521038e88d6a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d7a29b21cb69b524b09b88e90c3bcc8966932da13d821479bf9c7cc968b5225"
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
