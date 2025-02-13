class Crlfmt < Formula
  desc "Formatter for CockroachDB's additions to the Go style guide"
  homepage "https://github.com/cockroachdb/crlfmt"
  url "https://github.com/cockroachdb/crlfmt/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e2862e41ff3553e86513797e9e8bce890526d82fc6a0fe42efffc140b12ae1a5"
  license "Apache-2.0"
  head "https://github.com/cockroachdb/crlfmt.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be4ece60f4fc4dba16581bc96919333aad12c5f39b5c56da9205c68306649847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "432995552c8a2d87a374407d52b391406c6bcd85d5f6257d7a3e65a30859b306"
    sha256 cellar: :any_skip_relocation, ventura:       "6c1b715e6cee129a23a0a2b5f1796c5d93934de29dc66375b9a39c7c43d604b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7e96e651956d88f355f39929a22ae3cb6217cf9cd9e1ebfcc18e6aafcc695f6"
  end

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
