class Packemon < Formula
  desc "Terminal tool for generating and monitoring packets"
  homepage "https://github.com/ddddddO/packemon"
  url "https://github.com/ddddddO/packemon/archive/refs/tags/v1.8.24.tar.gz"
  sha256 "f5b6ee1126bc80901afb23c3b9cf99eed59f2708514d4e1306840582889f2982"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/packemon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19a3f47af77889cdcc0e31a0a94f70f76b9f7a1c277f19ded08cb621e2dd7597"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7d3c8e0f146440c494dc0b7d07a1654d530fb9a04fc49f314ce6b845b3ccade"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba9d1c6ade5e9fd40204ca1a2fa937a5a9689abbc776f60af72aab8e5138be15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7553e04767cf901f5f8303df4f9dc9c93d0503590827f092c2b5a5b675404d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9154fe6b59aa1cf8e794ca2d6cdf96341aed34632dc4cbe746291c227d13ad5"
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
