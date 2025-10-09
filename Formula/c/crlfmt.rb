class Crlfmt < Formula
  desc "Formatter for CockroachDB's additions to the Go style guide"
  homepage "https://github.com/cockroachdb/crlfmt"
  url "https://github.com/cockroachdb/crlfmt/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e2862e41ff3553e86513797e9e8bce890526d82fc6a0fe42efffc140b12ae1a5"
  license "Apache-2.0"
  revision 1
  head "https://github.com/cockroachdb/crlfmt.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10cae0690c75f1cc4472e55d218f7227f5e4820e6484de961ee7a3c2af83ba08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10cae0690c75f1cc4472e55d218f7227f5e4820e6484de961ee7a3c2af83ba08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10cae0690c75f1cc4472e55d218f7227f5e4820e6484de961ee7a3c2af83ba08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "948ccd6c07a4120d699c0869224d15a6850ff4866a50b7eb053ee27007adf60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6801133bb2f575c7f4c8a3181f664268d91b9d8f66cda484f63bac5c0d9d3d2"
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
