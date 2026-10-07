class Tetrigo < Formula
  desc "Play Tetris in your terminal"
  homepage "https://github.com/Broderick-Westrope/tetrigo"
  url "https://github.com/Broderick-Westrope/tetrigo/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "0347e2739e6fd7fc37667eb8873030f700d26e824d124d73ff8eb49c910946a8"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04103e300f06fe3e92813d8017891d37c83da87c64bacda897a4192521691ab3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51c83dd61310ae4555202fd77ee58978e746a0a4635d7ce5c9e737caa4bc9504"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c066c7082e5ae3a53f05c0c1f988810133dc4ab8fb76fea328d275a4020af28"
    sha256 cellar: :any,                 x86_64_linux:  "1a389f00a79c6ecc55e1a680580c6e3a6918e028b08952cdd6ccb9b5fd378258"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tetrigo"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"tetrigo", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
