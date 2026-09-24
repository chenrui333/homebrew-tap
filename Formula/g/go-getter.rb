class GoGetter < Formula
  desc "Package for downloading things from a string URL using a variety of protocols"
  homepage "https://github.com/hashicorp/go-getter"
  url "https://github.com/hashicorp/go-getter/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "dd1a756c5a36cc73d01a47fd9d01430756a426581b8ca42003c934a289d3b54a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/go-getter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e294afca5e3fccd9a99562c25db98d4b341a0ef4e767e3b08ce3202d781bed7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e294afca5e3fccd9a99562c25db98d4b341a0ef4e767e3b08ce3202d781bed7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f300d9e487639a5a5fbd6db91c7029ffddb8d4a093d802bb171fdbed885eb466"
    sha256 cellar: :any,                 x86_64_linux:  "8c82d71c03c02b59f2f50eee8eeeba0b1ad82f628ad6dac80983a931271b5848"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.GitCommit=#{version}"
    cd "cmd/go-getter" do
      system "go", "build", *std_go_args(ldflags:), "."
    end
  end

  test do
    (testpath/"src.txt").write("hi")
    system bin/"go-getter", "file://#{testpath}/src.txt", testpath/"dst"
    assert_equal "hi", (testpath/"dst/src.txt").read
  end
end
