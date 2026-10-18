class Packemon < Formula
  desc "Terminal tool for generating and monitoring packets"
  homepage "https://github.com/ddddddO/packemon"
  url "https://github.com/ddddddO/packemon/archive/refs/tags/v1.8.33.tar.gz"
  sha256 "e36c18f8ba326fc370c40bff5ac21dfc90a712be810f40185f86147a1551a7f7"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/packemon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a80b050782eae49f97cab3ffc4067760a3b84ad1a2e13617087338243e8b757"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c7976273e75dae23f3c86b4a40b56993b59d25b3f85e8221267ee9cce7ae469"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1435d1f764d0474bd46198d06f1d6bb1d0d395af579f77f31de72c4563439cf"
    sha256 cellar: :any,                 x86_64_linux:  "f762523419574f753c8c2384069b45a183d655a78969209d74e228cbd01081d9"
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
