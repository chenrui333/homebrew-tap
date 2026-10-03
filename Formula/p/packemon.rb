class Packemon < Formula
  desc "Terminal tool for generating and monitoring packets"
  homepage "https://github.com/ddddddO/packemon"
  url "https://github.com/ddddddO/packemon/archive/refs/tags/v1.8.31.tar.gz"
  sha256 "a111613f519585a184242133eeed13731394e7fdbe660ebc336ad5fa50195b57"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/packemon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9298214ba1012c1ca52559460740bef4237114ab14642f48cbbbbe477d3edd3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0c35860081a0e40429adcdac1e46fc5ee0e517e0ebf4ddaec41aab35cc2a594"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e0fdf63406286cfb32b1f1a5ccfe1d966cbb31166ccb741ed57cf7823590780"
    sha256 cellar: :any,                 x86_64_linux:  "c8151284e0d8e154b254d23279cb2a05b4002b1d63c15e354aadf85ffac7c774"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=brew"
    system "go", "build", *std_go_args(ldflags:), "./cmd/packemon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/packemon version")

    interfaces = JSON.parse(shell_output("#{bin}/packemon interfaces --json"))
    assert_kind_of Array, interfaces
    refute_empty interfaces
    assert_kind_of Hash, interfaces.first
    assert interfaces.first.key?("InterfaceName")
  end
end
