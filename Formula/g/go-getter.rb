class GoGetter < Formula
  desc "Package for downloading things from a string URL using a variety of protocols"
  homepage "https://github.com/hashicorp/go-getter"
  url "https://github.com/hashicorp/go-getter/archive/refs/tags/v1.8.9.tar.gz"
  sha256 "b53f5f28ed9e255bb90c8edd03556fdaf6f8deb96fa28ad463576afd6b49ad3e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/go-getter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d282516abda633347d3ed0aea981f70280d973487f69176c79cccb3fcd04b653"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d282516abda633347d3ed0aea981f70280d973487f69176c79cccb3fcd04b653"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d282516abda633347d3ed0aea981f70280d973487f69176c79cccb3fcd04b653"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b5da4755b36189547a3f9df24894c67ed2ac3612ab7175e0187a13a1a37dc4a"
    sha256 cellar: :any,                 x86_64_linux:  "7292434a0a483dd9f2841890b8f83d7451103f34e2df9576229c0ecb9457818f"
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
