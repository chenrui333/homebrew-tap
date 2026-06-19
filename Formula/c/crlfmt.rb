class Crlfmt < Formula
  desc "Formatter for CockroachDB's additions to the Go style guide"
  homepage "https://github.com/cockroachdb/crlfmt"
  url "https://github.com/cockroachdb/crlfmt/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "819a564a01d27c2a4033327b4db129dbccea505c6623fe6735e957eef338eb8d"
  license "Apache-2.0"
  head "https://github.com/cockroachdb/crlfmt.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "990baa160ce3c3045ec7ca707e85174196ceae941042135091cea606ea4b8096"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "990baa160ce3c3045ec7ca707e85174196ceae941042135091cea606ea4b8096"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "990baa160ce3c3045ec7ca707e85174196ceae941042135091cea606ea4b8096"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dda4f38b67b8588a3d4b5645fe618787daacced305f231b44b27456576627e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f12403bb0847d76d1f1311a0c4c8fe026976b94d3320d822311e17e62bb6002d"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    (testpath/"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello, World!")
      }
    GO

    system bin/"crlfmt", "-w", "-tab", "2", testpath/"test.go"
    expected_content = <<~GO
      package main

      import "fmt"

      func main() {
      \tfmt.Println("Hello, World!")
      }
    GO

    assert_equal expected_content, (testpath/"test.go").read
  end
end
