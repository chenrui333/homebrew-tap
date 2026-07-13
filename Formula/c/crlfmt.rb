class Crlfmt < Formula
  desc "Formatter for CockroachDB's additions to the Go style guide"
  homepage "https://github.com/cockroachdb/crlfmt"
  url "https://github.com/cockroachdb/crlfmt/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "819a564a01d27c2a4033327b4db129dbccea505c6623fe6735e957eef338eb8d"
  license "Apache-2.0"
  head "https://github.com/cockroachdb/crlfmt.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c06c43f8c256bda8dce73eb3dbf69b42b373c89899442784b2f19205a541e4a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c06c43f8c256bda8dce73eb3dbf69b42b373c89899442784b2f19205a541e4a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c06c43f8c256bda8dce73eb3dbf69b42b373c89899442784b2f19205a541e4a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1a5c5c399592e365347eed47b384488ce4314e66d1e63c005a6106514d6536f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0a61b596e554534c6377915f1892810aa429a30f1400becee043c17fedb1aae"
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
