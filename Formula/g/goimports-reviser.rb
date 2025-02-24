class GoimportsReviser < Formula
  desc "Right imports sorting & code formatting tool (goimports alternative)"
  homepage "https://github.com/incu6us/goimports-reviser"
  url "https://github.com/incu6us/goimports-reviser/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "fc580098fbbdac968e34556fd8de01fac0caae232e8644ae8ae14105582bcac1"
  license "MIT"
  head "https://github.com/incu6us/goimports-reviser.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1e57f0d9b5e79a5996c17ec7cafb05ce4f0172717dcc0f11968f1161e7b1daf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cac94affaf4ff0db5e901366e2349c9b76f5316af785b2ffa34b228ba443cdc"
    sha256 cellar: :any_skip_relocation, ventura:       "a8eabf5cb6489a00310d3602a3e73c336ffb1ef9d52a7f1566eff52cbaf8e5aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31a4836bbfa6a89256c27e31ca407e83b8fde5e6fd14420fad3339db736f4c5c"
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
