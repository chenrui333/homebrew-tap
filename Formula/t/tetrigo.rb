class Tetrigo < Formula
  desc "Play Tetris in your terminal"
  homepage "https://github.com/Broderick-Westrope/tetrigo"
  url "https://github.com/Broderick-Westrope/tetrigo/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "0347e2739e6fd7fc37667eb8873030f700d26e824d124d73ff8eb49c910946a8"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ad33793127fa7ce534fd13ec9f27c8d50089d5eb9778ada3b34015edf46eda0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf3b9db3d8f573d6a918f511fe0f51d8533e96ec951b4eb0bc9e7f747ee1cee2"
    sha256 cellar: :any_skip_relocation, ventura:       "898c62336a0e0f6431c1e94e4b4b7deabe475e97aec0d96ea95e3f498378f9b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb5621ebefd0938b07efaa0b420e131280e02fc0cb366d98e7bb1d6e283fac61"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tetrigo"
  end

  test do
    assert_match "tetris TUI written in Go", shell_output("#{bin}/tetrigo --help")
  end
end
