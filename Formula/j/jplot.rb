class Jplot < Formula
  desc "ITerm2 expvar/JSON monitoring tool"
  homepage "https://github.com/rs/jplot"
  url "https://github.com/rs/jplot/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "e2d1aa4cf81a61cdcea0b190f18a8ee7502093faf77c48f54c2741b457b4f298"
  license "MIT"
  head "https://github.com/rs/jplot.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47ba3c04f5c7da7026225ccd75d15db6121bcb9be040509b14280999c0da0f01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0854a077f93f22da91a121589bedeecdfbc21b6785fa494d20a640a22bac504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85082e1077b3643ef45108c39c8c584615f5d6af665347838c17f31061f213eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3476ba69a353ffa6dbdf07f2d152ecde98aed08414b5b3a9735ad8d2f75de89d"
    sha256 cellar: :any,                 x86_64_linux:  "9fd88b4c8ed443fb2b3feeec5369cb05ac59651f45fb7577a4d88a7cafeeb71a"
  end

  depends_on "go" => :build

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
