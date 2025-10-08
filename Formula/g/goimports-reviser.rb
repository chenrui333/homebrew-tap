class GoimportsReviser < Formula
  desc "Right imports sorting & code formatting tool (goimports alternative)"
  homepage "https://github.com/incu6us/goimports-reviser"
  url "https://github.com/incu6us/goimports-reviser/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "78a56fd0bec395d41b7c03f88a5444d699678a2d5d3f48a33acfff89687f5ced"
  license "MIT"
  revision 1
  head "https://github.com/incu6us/goimports-reviser.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3b3ceeafd75ee5862817a1ae7c618c9001ba4f11f34ec94fba70c7905b74170"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c664bdd1ee8018affc8bcddd5cd9f51ad2210dda41827b990853bbf6c132a0b5"
    sha256 cellar: :any_skip_relocation, ventura:       "2fe0b04b86e870b6bc012ac1d9094738423a0f2c625ed3e8279ad97b5a4de06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2a4ab0619b0367325dfb82d277d808d48d7adeec597e160cc4fdf6751e0cb72"
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
