class GoGetter < Formula
  desc "Package for downloading things from a string URL using a variety of protocols"
  homepage "https://github.com/hashicorp/go-getter"
  url "https://github.com/hashicorp/go-getter/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "0ca1e2dc258de76ac8c061635a6a046d22924766bb46b6167a1659f5d4e4f159"
  license "MPL-2.0"
  head "https://github.com/hashicorp/go-getter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc69b75d576ad1f40b11fc429d351b3085c9a2894b80e8dd6c73332230f46e9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc69b75d576ad1f40b11fc429d351b3085c9a2894b80e8dd6c73332230f46e9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc69b75d576ad1f40b11fc429d351b3085c9a2894b80e8dd6c73332230f46e9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc824089b841deecc96e0f1c558597579edebe91d87305f9c958bb4ac1f0f89c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "464dfc82274e6e3aa9f94ceabee154d3c0e689fc8c237c1db4c9c1ce1a7425a6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.GitCommit=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/go-getter"
  end

  test do
    (testpath/"src.txt").write("hi")
    system bin/"go-getter", "file://#{testpath}/src.txt", testpath/"dst"
    assert_equal "hi", (testpath/"dst/src.txt").read
  end
end
