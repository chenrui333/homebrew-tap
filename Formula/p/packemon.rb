class Packemon < Formula
  desc "Terminal tool for generating and monitoring packets"
  homepage "https://github.com/ddddddO/packemon"
  url "https://github.com/ddddddO/packemon/archive/refs/tags/v1.8.31.tar.gz"
  sha256 "a111613f519585a184242133eeed13731394e7fdbe660ebc336ad5fa50195b57"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/packemon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef339b559cf950f4be5feed0c8e31bcd1bcdf12b4a4f0cf47150cc46814bb24d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4299297dd9ad64fe0a63ff9706190451bad36f1c8584e7a3dc91efd921e2e2fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85d38b549c9c7473f9348107778c8bef0a77d43737b35f9d9901a80f3f62ee7d"
    sha256 cellar: :any,                 x86_64_linux:  "8abcc09ed0150e164680e70b38184be2859ca84f836771712185c9e7304e773e"
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
