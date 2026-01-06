class GoGetter < Formula
  desc "Package for downloading things from a string URL using a variety of protocols"
  homepage "https://github.com/hashicorp/go-getter"
  url "https://github.com/hashicorp/go-getter/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "fb4d42583398e09715c44f208cd11bb45489d670577d1f2aa6974d029ba6accd"
  license "MPL-2.0"
  head "https://github.com/hashicorp/go-getter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f035d3f9daa00acd4b53abd297340f4cea2b5c0fa4f95dd5fc534775fcd6f3bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f035d3f9daa00acd4b53abd297340f4cea2b5c0fa4f95dd5fc534775fcd6f3bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f035d3f9daa00acd4b53abd297340f4cea2b5c0fa4f95dd5fc534775fcd6f3bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d358c266be2ec62c19d6cd376ea8d6aefa181923c9f643f51d307df787f32815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "365794547392d3c1ce8c8149f424d5283a302a7c45a359f03c9195f84fc4f9c9"
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
