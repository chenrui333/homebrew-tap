class GoGetter < Formula
  desc "Package for downloading things from a string URL using a variety of protocols"
  homepage "https://github.com/hashicorp/go-getter"
  url "https://github.com/hashicorp/go-getter/archive/refs/tags/v1.8.8.tar.gz"
  sha256 "2a4523324815fe63faa38fb08bd51b4c5e56cac7ab59990323b4e9fa277d3951"
  license "MPL-2.0"
  head "https://github.com/hashicorp/go-getter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faae611c8ac94f931d166354c31021dc160cd5e592489f30e4279bb11b2285b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faae611c8ac94f931d166354c31021dc160cd5e592489f30e4279bb11b2285b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faae611c8ac94f931d166354c31021dc160cd5e592489f30e4279bb11b2285b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ff05a90f641d66a18ef71e27b3f120887abc6a4c72a65d9d4a92ec9f04809ad"
    sha256 cellar: :any,                 x86_64_linux:  "2d9ce6c7181e7f0a7cda1daab951f5d2b917cc7dbfc9542a0be5661b42bdb5bc"
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
