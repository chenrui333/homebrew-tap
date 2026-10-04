class Packemon < Formula
  desc "Terminal tool for generating and monitoring packets"
  homepage "https://github.com/ddddddO/packemon"
  url "https://github.com/ddddddO/packemon/archive/refs/tags/v1.8.32.tar.gz"
  sha256 "4f27770ba27113947c5c1de55bcba6b5c87bba497b21cd1a74cec565aabed535"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/packemon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f606a10c92a9317322d5c49e25a320253dbce7973ea7f2237e4f1424329f95b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "920528839ceb980dd4d9c5c283e70081937e34fa8d63a08ee241d5482857aaa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00cdfe6bcdc06e0821ae727b4b8b2fe8ec927a591b70ac13b7e31e8ad466515c"
    sha256 cellar: :any,                 x86_64_linux:  "c8d5583c2e4e3ef56d79ca1516bae1da5d5307db9c722e04f05cac989ee617bf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
