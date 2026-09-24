class Lsoff < Formula
  desc "List listening TCP and UDP ports"
  homepage "https://github.com/yutat23/lsoff"
  url "https://github.com/yutat23/lsoff/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "25117f42705801040ea63bf09cf6396a063d54c0087a7ce6a57554195b5f17ae"
  license "MIT"
  head "https://github.com/yutat23/lsoff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1436ceb3d558d41cec687c515f2782eb61d2ca22c3990574ad480bd16f6dad19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f8cab6d1ccac57fb361d3857702cab4e0a5ca8bb8feb4fc01f48b1da185cd39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "655d24721a1597d379842cedf95f85db2b8f5992c44c699697f6193e5676c43c"
    sha256 cellar: :any,                 x86_64_linux:  "a8befb73f2528e6470c2acfc2f5f56cd0a0a47236a2b6c909f05b3d85fb14a27"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lsoff --version")
    output = shell_output("#{bin}/lsoff --kill 2>&1", 2)
    assert_match "-k requires a port", output
  end
end
