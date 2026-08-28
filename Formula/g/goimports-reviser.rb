class GoimportsReviser < Formula
  desc "Right imports sorting & code formatting tool (goimports alternative)"
  homepage "https://github.com/incu6us/goimports-reviser"
  url "https://github.com/incu6us/goimports-reviser/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "2af9b83f9457e2111100b2d2cb48ac5abfc20132e662424baa5958a90d7c45a9"
  license "MIT"
  head "https://github.com/incu6us/goimports-reviser.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30983299949da92fb54290be9cfa59b63af26479da5f207815cab80f29243b04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30983299949da92fb54290be9cfa59b63af26479da5f207815cab80f29243b04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30983299949da92fb54290be9cfa59b63af26479da5f207815cab80f29243b04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "597bc50044b4d6f47b90dc3230a0db74c990b86eba158fe3cd1e0503ca6f0051"
    sha256 cellar: :any,                 x86_64_linux:  "4aaba9de11aa25684ff6ec293b32e4b541416bc81babe12791413c239265006b"
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
