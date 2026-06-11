class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://github.com/patriceckhart/zot"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.15.tar.gz"
  sha256 "1a6756cb64a9bae31f2769de2b4cf9fa6560b31295eda048a31a447e0c991e11"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3749d3dc55aba41a80d9b6d4c6f7d8703343f873a72e5dbbc196b4e3867ed070"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3749d3dc55aba41a80d9b6d4c6f7d8703343f873a72e5dbbc196b4e3867ed070"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3749d3dc55aba41a80d9b6d4c6f7d8703343f873a72e5dbbc196b4e3867ed070"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6313038c4f9328d76f15887e4dd28f17f7290bef431d2b48313a60acd928fd77"
    sha256 cellar: :any,                 x86_64_linux:  "897166e3b132153370dabf7987f08be32a159666c360f9d51c70d7062c42f24e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
