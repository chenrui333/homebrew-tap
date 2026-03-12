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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e131d538bffe0bf7cdbac20df240ba0bd38800617ad668dbe921459fc374c9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e131d538bffe0bf7cdbac20df240ba0bd38800617ad668dbe921459fc374c9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e131d538bffe0bf7cdbac20df240ba0bd38800617ad668dbe921459fc374c9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd7aa2f7a3dd665fda399f2e929f60cf2271d1d069ac29a03fdffae183e45cb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7593799783fc512432e12a5acf5ea2e576a26f0f152bc3c12b09d3c8ea4ff3d8"
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
