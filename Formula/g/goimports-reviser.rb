class GoimportsReviser < Formula
  desc "Right imports sorting & code formatting tool (goimports alternative)"
  homepage "https://github.com/incu6us/goimports-reviser"
  url "https://github.com/incu6us/goimports-reviser/archive/refs/tags/v3.13.2.tar.gz"
  sha256 "17c90e414f492cb1d0444845655b45729bf0636d6f421a3b17180702713a3934"
  license "MIT"
  head "https://github.com/incu6us/goimports-reviser.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be3183d84e37fc4f77a6d2bbd1aa2f8da1b0388ef73a46c3795e07093ea29cd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be3183d84e37fc4f77a6d2bbd1aa2f8da1b0388ef73a46c3795e07093ea29cd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be3183d84e37fc4f77a6d2bbd1aa2f8da1b0388ef73a46c3795e07093ea29cd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e5ccd9c7388d9deee7d08a5321517c12d3fa4ba1e20cdec99095e1d7b53d666"
    sha256 cellar: :any,                 x86_64_linux:  "93b4495c030350d71a7b2fddb95a927cc6c3d14e9f167996a71ba4261dcc49e3"
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
