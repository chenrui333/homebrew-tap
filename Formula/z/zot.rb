class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://github.com/patriceckhart/zot"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.15.tar.gz"
  sha256 "1a6756cb64a9bae31f2769de2b4cf9fa6560b31295eda048a31a447e0c991e11"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "coding agent harness", shell_output("#{bin}/zot --help 2>&1")
  end
end
