class GoimportsReviser < Formula
  desc "Right imports sorting & code formatting tool (goimports alternative)"
  homepage "https://github.com/incu6us/goimports-reviser"
  url "https://github.com/incu6us/goimports-reviser/archive/refs/tags/v3.8.2.tar.gz"
  sha256 "251eee4880f6f6d73f55cf38a361c5aa419c55e5ea41eb7db0eb1aec413f06e7"
  license "MIT"
  head "https://github.com/incu6us/goimports-reviser.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbc56f8e8ea4b958bc5d60691f06e1cde18d1e1ee519368f728ed4b5738b4d4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc740016f123bf85366a3403467206c2e865fef6087e4ddffb5dbed605a303aa"
    sha256 cellar: :any_skip_relocation, ventura:       "228c6ef10b34753073fef28c21ddb556a4ce3da050e9c5c749f1a47d3fc0729f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "226a17aff041080725e844f6e6ab6ce890ae0e25f71ffd93593b993099fd291f"
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
