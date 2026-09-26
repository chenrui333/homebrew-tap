class Packemon < Formula
  desc "Terminal tool for generating and monitoring packets"
  homepage "https://github.com/ddddddO/packemon"
  url "https://github.com/ddddddO/packemon/archive/refs/tags/v1.8.27.tar.gz"
  sha256 "cb0694a94464fbd577309dda725b981089b19ff516fe4007cc770ca4caaa7e03"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/packemon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e58667b3706677de2283fbc1c9a95a619630edcf025350e40bd81baa483b7300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f5f5c08ff8cacfa1f38bdc9729ade970c6c6f10ed06ec507426c1c48f358eef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4050840721c6ef5774550ae783f52e3805b193eb1997a0a2275cffd825627679"
    sha256 cellar: :any,                 x86_64_linux:  "a99d575a1a13352e97d825bb17c9d0002f9c3dca384e6ea275fd19e82fcd1a39"
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
