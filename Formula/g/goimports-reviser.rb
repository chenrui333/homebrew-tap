class GoimportsReviser < Formula
  desc "Right imports sorting & code formatting tool (goimports alternative)"
  homepage "https://github.com/incu6us/goimports-reviser"
  url "https://github.com/incu6us/goimports-reviser/archive/refs/tags/v3.12.5.tar.gz"
  sha256 "90b97c2ae009e858e665bf26c5b20da0a360d1b3f7066549ed26a42fbde1c1db"
  license "MIT"
  head "https://github.com/incu6us/goimports-reviser.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "543e96f79557919dac05f5d79243ce40c388e2f151c06986e849ad739f24a853"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "543e96f79557919dac05f5d79243ce40c388e2f151c06986e849ad739f24a853"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "543e96f79557919dac05f5d79243ce40c388e2f151c06986e849ad739f24a853"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b2a0d12358b1335e31805a1ff2a55d4b901d4efc73207a5079436d29a1da1b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1c9e0869fc097c75b555e1de7d88af350bc5b6f4366bc6b8d21761ddf5ffd9e"
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
