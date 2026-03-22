class Packemon < Formula
  desc "Terminal tool for generating and monitoring packets"
  homepage "https://github.com/ddddddO/packemon"
  url "https://github.com/ddddddO/packemon/archive/refs/tags/v1.8.21.tar.gz"
  sha256 "843acc971cf5191fd7d06266a582444f478372a2232e77497dc3e73be23b2b77"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/packemon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0065efa4c202077bc12b925452e422a6152bfb43fdb000fbed0a2efc0486a9f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23c312fa724e0a37dbfcff6e3f73a79f6b65b71053e1298c7a1692d97ce7d4f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d50f6de3bc1355f224f8445d67a5abdcc6735db3f6b406a33b6ac793c2ef758"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ded1ed5d7c3ad64b4b411f05994e83dd55f92675db5007c40e8880934751904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "943cdf8a42a33549c9e068d77b389d47de72503f0048af5ced1cd353dc77f2d0"
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
