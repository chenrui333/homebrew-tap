class Jplot < Formula
  desc "ITerm2 expvar/JSON monitoring tool"
  homepage "https://github.com/rs/jplot"
  url "https://github.com/rs/jplot/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "e2d1aa4cf81a61cdcea0b190f18a8ee7502093faf77c48f54c2741b457b4f298"
  license "MIT"
  head "https://github.com/rs/jplot.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3f7cb3b203c610fd5617697ae6e0eee3d1a75614bfc05e8ed53af263f6d22cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d60c7f14ecf32a2017302cdc361bda949353453935ab064561cccb638ebb6b71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd0609a0abc6cd867127c5e45e9c4db79eb1a170e2c278ea74d18ba2ba545144"
    sha256 cellar: :any,                 x86_64_linux:  "6d5f9c5b38b6381fb930260ca9e6a2c47b21281809873eefef310e1e53fa6048"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"jplot", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
