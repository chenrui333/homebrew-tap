class Packemon < Formula
  desc "Terminal tool for generating and monitoring packets"
  homepage "https://github.com/ddddddO/packemon"
  url "https://github.com/ddddddO/packemon/archive/refs/tags/v1.8.26.tar.gz"
  sha256 "dabfcb37057090dbe54f12a9700f86504c059f4e4d8a28eab44c5a90fe679801"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/packemon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e114504f1d0808e90d3ea28429e20c2ad5695070952ddd4bbe4b3bc2d212feae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63939c3c7aa8a06483e2dd661649a27319ae6d8f8917701e4718da5b8291798d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf0835f173bb7f06798eecd1b7222bdc6fbf0a95c30309cf9c5864be75119f96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f201cc17b9b1871ab37247a99c4d2418854e367924eb813d61152bbf47c99bd"
    sha256 cellar: :any,                 x86_64_linux:  "09ea28649f471fff04bca19d1fadb8803f7e44d6f6e71518f67e1680c4610047"
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
