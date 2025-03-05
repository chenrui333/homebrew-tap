class Tetrigo < Formula
  desc "Play Tetris in your terminal"
  homepage "https://github.com/Broderick-Westrope/tetrigo"
  url "https://github.com/Broderick-Westrope/tetrigo/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "0347e2739e6fd7fc37667eb8873030f700d26e824d124d73ff8eb49c910946a8"
  license "GPL-3.0-or-later"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tetrigo"
  end

  test do
    assert_match "tetris TUI written in Go", shell_output("#{bin}/tetrigo --help")
  end
end
