class GoimportsReviser < Formula
  desc "Right imports sorting & code formatting tool (goimports alternative)"
  homepage "https://github.com/incu6us/goimports-reviser"
  url "https://github.com/incu6us/goimports-reviser/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "fc580098fbbdac968e34556fd8de01fac0caae232e8644ae8ae14105582bcac1"
  license "MIT"
  head "https://github.com/incu6us/goimports-reviser.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "883e47e8a1c9967352a0c2c234af3a71073f3f3aa68fd7d4c98697f0d8ecb769"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54b9901d2b3c57794a15bec03b8822f479c1d58e5ebd60af8344e07b764ce1f6"
    sha256 cellar: :any_skip_relocation, ventura:       "dde30efbfe33ce9e7d667e474a3cb6d3dcc99e177459a1c96b1cc964b17f0e67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "331fa98150ab84a3a3b2b37a11cef90012f0248e7f68d30f8f72602acd2fa2d5"
  end

  depends_on "go" => :build

  def install
    go_version = Formula["go"].version
    ldflags = %W[
      -s -w
      -X main.Tag=v#{version}
      -X main.Commit=v#{version}
      -X main.SourceURL=https://github.com/incu6us/goimports-reviser
      -X main.GoVersion=go#{go_version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # `-version` has other info as GoVersion, source, and commit
    # `-version-only` just prints the version
    assert_match version.to_s, shell_output("#{bin}/goimports-reviser -version-only")

    (testpath/"main.go").write <<~GO
      package main

      import (
        "fmt"
        "os"
      )

      func main() {
        fmt.Println("Hello, World!")
        os.Exit(0)
      }
    GO

    system bin/"goimports-reviser", "-project-name", "main", testpath/"main.go"
    expected_content = <<~GO
      package main

      import (
      \t"fmt"
      \t"os"
      )

      func main() {
      \tfmt.Println("Hello, World!")
      \tos.Exit(0)
      }
    GO

    assert_equal expected_content, (testpath/"main.go").read
  end
end
