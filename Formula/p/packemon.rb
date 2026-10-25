class Packemon < Formula
  desc "Terminal tool for generating and monitoring packets"
  homepage "https://github.com/ddddddO/packemon"
  url "https://github.com/ddddddO/packemon/archive/refs/tags/v1.8.34.tar.gz"
  sha256 "9db81c0b39784293d225393f9a67cc77faf8bb6f2449f721ce365f8437f98eaa"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/packemon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad71ec60bf7b75870e4549dafb335fdf3a5f7ef42d131e8be377e0150fa7149a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9be65febb46fc481358d150b82db34731ad6e992b5fca063932c9a705d4a5f11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f08fb8d5f417fa9a9c0f4f2c9d0926e78f8882764f7f0bed0ee9201c04c079e8"
    sha256 cellar: :any,                 x86_64_linux:  "8c448015226a9bc7240a4ca77a6a35696087635e0ad4e3fa9e61fbfc31ae78e0"
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
