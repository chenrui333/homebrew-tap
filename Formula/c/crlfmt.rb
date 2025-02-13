class Crlfmt < Formula
  desc "Formatter for CockroachDB's additions to the Go style guide"
  homepage "https://github.com/cockroachdb/crlfmt"
  url "https://github.com/cockroachdb/crlfmt/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e2862e41ff3553e86513797e9e8bce890526d82fc6a0fe42efffc140b12ae1a5"
  license "Apache-2.0"
  head "https://github.com/cockroachdb/crlfmt.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
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
