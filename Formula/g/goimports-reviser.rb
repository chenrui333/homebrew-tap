class GoimportsReviser < Formula
  desc "Right imports sorting & code formatting tool (goimports alternative)"
  homepage "https://github.com/incu6us/goimports-reviser"
  url "https://github.com/incu6us/goimports-reviser/archive/refs/tags/v3.12.6.tar.gz"
  sha256 "f89b39bd6888c8a1919394c1d3dd2f622da38855f1709879c3fbdde8e6bf540b"
  license "MIT"
  head "https://github.com/incu6us/goimports-reviser.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8c440360621cdb997f138811a6cb95a771ce0607281a6b2913851dbde39ce58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8c440360621cdb997f138811a6cb95a771ce0607281a6b2913851dbde39ce58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8c440360621cdb997f138811a6cb95a771ce0607281a6b2913851dbde39ce58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdf985f6734c377f77a10b05a0f02762f7d45317af5b9b2197b58793e9c0c0bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "554562d016b50a29ff1a68413e00e1627dfe6ccad8ae34c346ed46e87b3273f0"
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
