class Gowebly < Formula
  desc "Next-generation CLI tool to easily build amazing web applications"
  homepage "https://gowebly.org/"
  url "https://github.com/gowebly/gowebly/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "f69c582180408a45c1f6a728594f39a617410d3b774be4d8236466e3ea4536e5"
  license "Apache-2.0"
  head "https://github.com/gowebly/gowebly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cfd120315b31564b07d3465dec1e7979fd045eec3bd84b62a00c33d78d03ddf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57d3530956a74c1137c73b6f641a564680c6fc5110d7f9123cca4b6411bb88ab"
    sha256 cellar: :any_skip_relocation, ventura:       "8b8c033086ceab0b376e17a8b5a74ed6c9c435b698f8fc99c0ef7b87c4d708c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30cab6fd1fcdb3a13ac9e79aef049f1333cc1e4068e7e466d9ba42b24c92ae65"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowebly doctor")

    output = shell_output("#{bin}/gowebly run 2>&1", 1)
    assert_match "No rule to make target", output
  end
end
