class GoGetter < Formula
  desc "Package for downloading things from a string URL using a variety of protocols"
  homepage "https://github.com/hashicorp/go-getter"
  url "https://github.com/hashicorp/go-getter/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "480e8106fe50127a4e5329cc5d09909cc2d7b48dfee80d6681679f483b3c560e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/go-getter.git", branch: "master"

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
