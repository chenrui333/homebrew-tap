class Packemon < Formula
  desc "Terminal tool for generating and monitoring packets"
  homepage "https://github.com/ddddddO/packemon"
  url "https://github.com/ddddddO/packemon/archive/refs/tags/v1.8.25.tar.gz"
  sha256 "4ec19a63d155c7e7854608e9813d53a01631308369dea5d387d69f0705258616"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/packemon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "184aa2389beeae79832795b2211d651e11a946a8707f9d2c6c8e7926b79f3f2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d647047492e9ae4d54f47763ccd16d32d2e380c650473fefe89f63816b3d4c49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd555d0c2f42f12327e998d46a5a1fd9baff2234e24e5fbba14419eb5bae224c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd9ff281d524b055ecbb86ff6cf2876c90b1349eb215137b0b93802339273b8d"
    sha256 cellar: :any,                 x86_64_linux:  "4fc73773099e91bc133d27df1a9a18b9f0a20f78713448483b4717c136e5ecb5"
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
