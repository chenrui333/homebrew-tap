class Mamediff < Formula
  desc "TUI editor for managing unstaged and staged Git diffs"
  homepage "https://github.com/sile/mamediff"
  url "https://github.com/sile/mamediff/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "41ccb6db241f4b0bee5a2b7a95735d15bcc30f1d7e9da54fc66e5c2f8e680fe0"
  license "MIT"
  head "https://github.com/sile/mamediff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db76c66b92602091157b5af4e4674d6108c106c539d38816d47c65f208783c6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "354d95161163a6a663992b844d0341522b10f4badb9977e776b8f6782023670b"
    sha256 cellar: :any_skip_relocation, ventura:       "20f7cf27a561fe75af820e5659a63130a9f296556d8cbc88b510d96cfee62507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17d8c4cbb48662cdf12f44e5f6400fff00517f60dc8962ea6ad121b0e163fd51"
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
