# framework: cobra
class Evans < Formula
  desc "More expressive universal gRPC client"
  homepage "https://github.com/ktr0731/evans"
  url "https://github.com/ktr0731/evans/archive/refs/tags/v0.10.11.tar.gz"
  sha256 "980177e9a7a88e2d9d927acb8171466c40dcef2db832ee4b638ba512d50cce37"
  license "MIT"
  head "https://github.com/ktr0731/evans.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "589043f45ce64a1e4a125c723657761ce1ee9f2c2e18138afa1f9b3d98656f46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1324831bf766c86c33947e5c05cfc536ad661267748433bb48308739afa3fe14"
    sha256 cellar: :any_skip_relocation, ventura:       "b185962ff6b3b87b99dca48a854856ea65a22c34316294656bf80dee1ad1b1c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02269ecc89f6971db5024e80296e235c6649e8b4bef895e60d9675a687f34b8e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evans --version")

    output = shell_output("#{bin}/evans -r cli list 2>&1", 1)
    assert_match "failed to list packages by gRPC reflection", output
  end
end
