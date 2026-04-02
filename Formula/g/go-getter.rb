class GoGetter < Formula
  desc "Package for downloading things from a string URL using a variety of protocols"
  homepage "https://github.com/hashicorp/go-getter"
  url "https://github.com/hashicorp/go-getter/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "a39e81e493cf64862b52c2bb6b49336d7730d12979d1f3d265aa0ca1a916e8ed"
  license "MPL-2.0"
  head "https://github.com/hashicorp/go-getter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c2ae265cd0f190bb4d13cbf26b3c2e9b976b1c67ee8f2d28de7a5b8f774c241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c2ae265cd0f190bb4d13cbf26b3c2e9b976b1c67ee8f2d28de7a5b8f774c241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c2ae265cd0f190bb4d13cbf26b3c2e9b976b1c67ee8f2d28de7a5b8f774c241"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bdc91c9dc18d65b272a10e1fcab4b5b6cb6115ef7c04cec73ea3096937360c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d292f0b4657acb95c44641798e3584841b25f9527397af95bf91d8c0f977e90d"
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
